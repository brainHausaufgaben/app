import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brain_app/Pages/settings_page.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/notifier.dart';
import 'package:brain_app/Backend/notifications.dart';
void main() {
  runApp(const BrainApp());
}

class BrainApp extends StatefulWidget {
  const BrainApp({Key? key}) : super(key: key);

  static AppDesign design = AppDesign();

  static String todaysJoke = "Wird geladen...";
  static IconData icon = Icons.autorenew_rounded;

  static Notifier notifier = Notifier();

  @override
  _BrainApp createState() => _BrainApp();
}

class _BrainApp extends State<BrainApp> {
  @override
  void initState() {
    super.initState();

    BrainApp.notifier.addListener(() {
      setState(() {});
    });

    TimeTable.init();
    getBoxText();
    load();
    CustomNotifications.init();
    CustomNotifications.persistentNotification();
    //CustomNotifications.persistentNotification();
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );

    return MaterialApp(
      title: 'Brain Hausaufgabenheft',
      home: NavigationHelper(),
      theme: AppDesign.current.themeData,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ],
      supportedLocales: const [
        Locale('de', 'DE')
      ],
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: StretchingIndicator(),
          child: child!,
        );
      },
    );
  }

  Future<MapEntry<String, IconData>?> parseJokes() async {
    final rawData = await rootBundle.loadString("data/witze.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    for (List<dynamic> entry in listData) {
      DateTime parsedTime = DateTime.parse(entry[0]);
      DateTime now = DateTime.now();

      if (parsedTime.year == now.year && parsedTime.month == now.month && parsedTime.day == now.day) {
        IconData icon;

        switch (entry[1]) {
          case "Fun Fact":
            icon = Icons.lightbulb;
            break;
          case "Witz":
            icon = Icons.celebration;
            break;
          case "Tipp":
            icon = Icons.verified;
            break;
          case "Zitat":
            icon = Icons.format_quote;
            break;
          default:
            icon = Icons.celebration;
        }

        return MapEntry(entry[2], icon);
      }
    }
  }

  Future load() async{
    if (await SaveSystem.getSubjects() == null){
      TimeTable.saveEnabled = true;
      return;
    } else {
      TimeTable.saveEnabled = false;
    }

    for (Map item in await SaveSystem.getSubjects()) {
      List color = item["color"];
      Subject.fromID(
          item["name"], Color.fromARGB(255, color[0], color[1], color[2]),
          item["id"]);
    }

    if (await SaveSystem.getTimeTable() == null){
      TimeTable.saveEnabled = true;
      return;
    }
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 10; j++) {
        int id = await SaveSystem.getTimeTable()[i][j];
        if (id != 0) SubjectInstance(TimeTable.getSubject(id)!, i + 1, j);
      }
    }


    if (await SaveSystem.getHomework() == null){
      TimeTable.saveEnabled = true;
      return;
    }
    for (Map item in await SaveSystem.getHomework()) {
      List t = item["dueTime"];
      DateTime time = DateTime(t[0],t[1],t[2]);
      int id = item["SubjectID"];
      if(TimeTable.getSubject(id)!.getTime(TimeTable.getDayFromDate(time)) != null) Homework(TimeTable.getSubject(id)!,time, item["name"]);

    }
    TimeTable.saveEnabled = true;
  }

  void getBoxText() async {
    parseJokes().then((value) {
      setState(() {
        if (value != null) {
          BrainApp.todaysJoke = value.key;
          BrainApp.icon = value.value;
        } else {
          BrainApp.todaysJoke = "Keine Schule heute :)";
          BrainApp.icon = Icons.celebration;
        }
      });
    });
  }
}

class StretchingIndicator extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
        child: child,
        axisDirection: details.direction
    );
  }
}

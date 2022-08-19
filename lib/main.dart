import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/notifier.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Backend/event.dart';
import 'Backend/test.dart';

void main() {
  runApp(const BrainApp());
}

class BrainApp extends StatefulWidget {
  const BrainApp({Key? key}) : super(key: key);

  static Notifier notifier = Notifier();

  static String appVersion = "...";
  static TodaysMedia? todaysMedia;

  static Map<String, dynamic> preferences = {
    "showMediaBox": true,
    "persistentNotifications": false,
    "homeworkNotifications": false,
    "notificationTime": "16:00",
    "design": "Monochrome",
    "darkMode": false,
    "pinnedHeader": true,
    "daysUntilHomeworkWarning": 6,
    "calendarFormat" : 0
  };

  static void updatePreference(String key, dynamic value) async {
    preferences[key] = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case String:
        prefs.setString(key, value);
        break;
      case bool:
        prefs.setBool(key, value);
        break;
      case int:
        prefs.setInt(key, value);
        break;
    }
  }

  @override
  _BrainApp createState() => _BrainApp();
}

class _BrainApp extends State<BrainApp> {
  @override
  void initState() {
    super.initState();

    BrainApp.notifier.addListener(() => setState(() {}));
    getPreferences().then((value) => AppDesign.toggleTheme(BrainApp.preferences["design"]));
    getVersion();

    init().then((value) => setState((){}));
    // ElternPortalConnection.getHtml();
    //CustomNotifications.persistentNotification();
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      BrainApp.appVersion = packageInfo.version;
    });
  }

  Future init() async {
    TimeTable.init();
    await CustomNotifications.init();
    await getBoxText();
    await load();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationHelper.rootKey,
      title: 'Brain Hausaufgabenheft',
      initialRoute: "/",
      onGenerateRoute: NavigationRoutes.onGenerateRoute,
      theme: AppDesign.current.themeData,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
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

  Future getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BrainApp.preferences.forEach((key, value) {
        BrainApp.preferences[key] = prefs.get(key) ?? value;
      });
    });
  }

  Future<TodaysMedia?> parseJokes() async {
    final rawData = await rootBundle.loadString("data/witze.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    for (List<dynamic> entry in listData) {
      DateTime parsedTime = DateTime.parse(entry[0]);
      DateTime now = DateTime.now();

      if (parsedTime.year == now.year && parsedTime.month == now.month && parsedTime.day == now.day) {
        IconData icon;
        String type = entry[1];
        String content = entry[2];
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
          case "Vorschlag":
            icon = Icons.star_border;
            break;
          case "Ferien":
            icon = Icons.celebration;
            content = "Endlich Ferien!";
            break;
          default:
            icon = Icons.celebration;
        }

        return TodaysMedia(
            icon: icon,
            content: content,
            type: type
        );
      }
    }
    return null;
  }

  Future load() async{
    TimeTable.saveEnabled = false;

    dynamic subjects = await SaveSystem.getSubjects();
    if (subjects != null) {
      for (Map item in subjects) {
        List color = item["color"];
        Subject.fromID(
            item["name"], Color.fromARGB(255, color[0], color[1], color[2]),
            item["id"]);
      }
    }

    dynamic timetable = await SaveSystem.getTimeTable();
    if (timetable != null) {
      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 10; j++) {
          int id = timetable[i][j];
          Subject? subject = TimeTable.getSubject(id);
          if (id != 0 && subject != null) SubjectInstance(subject, i + 1, j);
        }
      }
    }


    dynamic homework = await SaveSystem.getHomework();
    if(homework != null) {
      for (Map item in homework) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        if (TimeTable.getSubject(id)!.getTime(TimeTable.getDayFromDate(time)) !=
            null) Homework(TimeTable.getSubject(id)!, time, item["name"]);
      }

    }

    dynamic events = await SaveSystem.getEvents();
    if(events != null) {
      for (Map item in events) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        Event(time, item["name"], item["description"]);
      }
    }

    dynamic tests = await SaveSystem.getTests();
    if(tests != null) {
      for (Map item in tests) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        Test(TimeTable.getSubject(id)!, time, item["description"]);
      }
    }

    dynamic grades = await SaveSystem.getGrades();
    if(grades != null) {
      for (Map item in await SaveSystem.getGrades()) {
        int value = item["value"];
        int id = item["SubjectID"];
        GradeTime time = GradeTime.createOnLoad(item["year"],item["partOfYear"],item["isAdvanced"]);

        if(item["isBig"]) {
          BigGrade.createWithTime(value,TimeTable.getSubject(id)!,time);
        } else {
          GradeType type = Grade.stringToGradeType(item["type"]);
          SmallGrade.createWithTime(value,TimeTable.getSubject(id)!,type,time);
        }

      }
    }

    TimeTable.saveEnabled = true;
  }

  Future getBoxText() async {
    parseJokes().then((value) {
      setState(() {
        if (value != null) {
          BrainApp.todaysMedia = value;
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

class TodaysMedia {
  TodaysMedia({
    required this.icon,
    required this.content,
    required this.type
  });

  final IconData icon;
  final String content;
  final String type;
}
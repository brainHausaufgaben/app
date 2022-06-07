import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Backend/time_table.dart';
import 'Backend/subject.dart';
import 'Backend/theming.dart';
import 'Pages/settings_page.dart';

void main() {
  // Kein Landscape
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  runApp(const BrainApp());
}

class BrainApp extends StatefulWidget {
  const BrainApp({Key? key}) : super(key: key);

  static String boxText = "Wird geladen...";
  static IconData icon = Icons.autorenew_rounded;

  @override
  _BrainApp createState() => _BrainApp();

}


class _BrainApp extends State<BrainApp> {
  @override
  Widget build(BuildContext context) {
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

  //an computi funktioniert nicht wenn das nicht rauskommentiert ist :(
  /*
  void databaseOperations() async{
    MyDatabase database = MyDatabase();
    await database.addTodo(TodosCompanion(name: Value("sus"), color: Value("sda") ));
    print(await database.allTodoEntries);
}
   */
  Future load() async{


    if (await SaveSystem.getSubjects() == null){
      TimeTable.saveEnabled = true;
      return;
    }
    else {
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
          BrainApp.boxText = value.key;
          BrainApp.icon = value.value;
        } else {
          BrainApp.boxText = "Keine Schule heute :)";
          BrainApp.icon = Icons.celebration;
        }
      });
    });
  }

  void getMediaBoxState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SettingsPage.mediaBox = prefs.getBool("mediaBox")!;
  }

  @override
  void initState() {
    super.initState();
    // Reloaded alle widgets wenn das Theme geändert wird
    currentDesign.addListener(() {
      setState((){});
    });
    TimeTable.init(this);
    getBoxText();
    getMediaBoxState();
    /*
    List<String> subjectsNames = ["Informatik","Mathematik","Deutsch","Englisch","Sport","Physik","Biologie","P Seminar Brain","W Seminar","Religion","Wirtschaft","Geschichte"];
    for(int sub = 0; sub < subjectsNames.length; sub++){
      Subject(subjectsNames[sub],Colors.primaries[sub]);
    }
    SaveSystem.saveSubjects();
    */

    load();



    //databaseOperations();


    //unnötig aber mir war langweilig
    /*
    List<String> names = ["schwanz", "cock", "amongus", "deutsch", "keine ahnung", "bubatz", "mathematik","hurensohn","er hat ein neues lied", "all meine entchen", "schwimmen auf dir", "kartoffelbrei", "jeremias", "fett", "sylenth1", "übergewichtig", "oh gott", "christian winkler", "bildungschicht","ähhh", "12 punkte schnitt", "nee es reicht glaub ich","birnenkomptt","keeenuuu weeeves", "ist wolkenmeer in diesem fall ein neologismus", "qrxvy (hund)", "batman", "five night freddy", "ich überlege", "gay lesson", "debug", "micheal","jackson","wendler bitter", "how to be GAYY!!", "trans learning", "gay recess", "crossdressing hour", "transgender lunch", "blm period"];
    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    Random random = Random();
    for(int sub = 0; sub < 10; sub++){
      Subject(names[random.nextInt(names.length)],Colors.primaries[random.nextInt(Colors.primaries.length)]);
    }


    for(int day = 1; day < 8; day++){
      for(int i = 1; i < TimeTable.lessonTimes.length; i++){
        SubjectInstance(TimeTable.subjects[random.nextInt(TimeTable.subjects.length)],day,i);
      }
    }
    */
    Random random = Random();
    //List<String> names = ["schwanz", "cock", "amongus", "deutsch", "keine ahnung", "bubatz", "mathematik","hurensohn","er hat ein neues lied", "all meine entchen", "schwimmen auf dir", "kartoffelbrei", "jeremias", "fett", "sylenth1", "übergewichtig", "oh gott", "christian winkler", "bildungschicht","ähhh", "12 punkte schnitt", "nee es reicht glaub ich","birnenkomptt","keeenuuu weeeves", "ist wolkenmeer in diesem fall ein neologismus", "qrxvy (hund)", "batman", "five night freddy", "ich überlege", "gay lesson", "debug", "micheal","jackson","wendler bitter", "how to be GAYY!!", "trans learning", "gay recess", "crossdressing hour", "transgender lunch", "blm period"];


/*
    for(int day = 1; day < 6; day++){
      for(int i = 0; i < TimeTable.lessonTimes.length; i++){
        SubjectInstance(TimeTable.subjects[random.nextInt(TimeTable.subjects.length)],day,i);
      }
    }
*/


/*
    for( int k = 1; k < 7; k++){
      for(SubjectInstance? subIn in TimeTable.getDay(k).subjects) {
        if (subIn != null) {
          for (int j = 0; j < 1; j++) {
            Homework(subIn.subject, subIn.getDate(), names[random.nextInt(names.length)]);
          }
        }
      }

    }

*/
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

import 'dart:math';


//import 'package:brain_app/Backend/data_store.dart';
import 'package:brain_app/Backend/subject_instance.dart';
//import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Backend/time_table.dart';
import 'Backend/subject.dart';
import 'Backend/theming.dart';
import 'Pages/home_page.dart';
import 'Pages/time_table.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();

}


class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Hausaufgabenheft',
      home: HomePage(),
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

  //an computi funktioniert nicht wenn das nicht rauskommentiert ist :(
  /*
  void databaseOperations() async{
    MyDatabase database = MyDatabase();
    await database.addTodo(TodosCompanion(name: Value("sus"), color: Value("sda") ));
    print(await database.allTodoEntries);
}
   */

  @override
  void initState() {
    super.initState();
    // Reloaded alle widgets wenn das Theme geändert wird
    currentDesign.addListener(() {
      setState((){});
    });
    TimeTable.init(this);
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
    List<String> subjectsNames = ["Informatik","Mathematik","Deutsch","Englisch","Sport","Physik","Biologie","P Seminar Brain","W Seminar","Religion","Wirtschaft","Geschichte"];
    for(int sub = 0; sub < subjectsNames.length; sub++){
      Subject(subjectsNames[sub],Colors.primaries[sub]);
    }
    for(int day = 1; day < 6; day++){
      for(int i = 0; i < TimeTable.lessonTimes.length; i++){
        SubjectInstance(TimeTable.subjects[random.nextInt(TimeTable.subjects.length)],day,i);
      }
    }


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
        axisDirection: AxisDirection.down
    );
  }
}

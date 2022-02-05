import 'dart:math';

import 'package:flutter/material.dart';
import 'Backend/time_table.dart';
import 'Backend/subject.dart';
import 'Backend/theming.dart';
import 'Pages/home_page.dart';

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
      // Der will dass HomePage const ist aber dann geht theming nichtmehr!!!
      home: HomePage(),
      theme: AppDesign.current.themeData
    );
  }

  @override
  void initState(){
    super.initState();
    // Reloaded alle widgets wenn das Theme geändert wird
    currentDesign.addListener(() {
      setState((){});
    });
    TimeTable.init();

    //unnötig aber mir war langweilig
    List<String> names = ["schwanz", "cock", "amongus", "deutsch", "keine ahnung", "bubatz", "mathematik","hurensohn","er hat ein neues lied", "all meine entchen", "schwimmen auf dir", "kartoffelbrei", "jeremias", "fett", "sylenth1", "übergewichtig", "oh gott", "christian winkler", "bildungschicht","ähhh", "12 punkte schnitt", "nee es reicht glaub ich","birnenkomptt","keeenuuu weeeves", "ist wolkenmeer in diesem fall ein neologismus", "qrxvy (hund)", "batman", "five night freddy", "ich überlege", "gay lesson", "debug", "micheal","jackson","wendler bitter", "how to be GAYY!!", "trans learning", "gay recess", "crossdressing hour", "transgender lunch", "blm period"];
    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    Random random = Random();
    for(int day = 1; day < 8; day++){
      for(int i = 1; i < TimeTable.lessons.length; i++){
        Subject(names[random.nextInt(names.length)],day,i,Colors.primaries[random.nextInt(Colors.primaries.length)]);
      }
      Subject(weekDays[day-1],day,0,Colors.black);
    }


  }


}



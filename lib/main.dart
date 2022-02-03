import 'dart:math';

import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utilities.dart';
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
      theme: ThemeData(
        primarySwatch: AppTheme.swatch,
      ),
      home: const HomePage(),
    );
  }

  @override
  void initState(){
    super.initState();
    TimeTable.init();

    //unnötig aber mir war langweilig
    List<String> names = ["schwanz", "cock", "amongus", "deutsch", "keine ahnung", "bubatz", "mathematik","hurensohn","er hat ein neues lied", "all meine entchen", "schwimmen auf dir", "kartoffelbrei", "jeremias", "fett", "sylenth1", "übergewichtig", "oh gott", "christian winkler", "bildungschicht","ähhh", "12 punkte schnitt", "nee es reicht glaub ich","birnenkomptt","keeenuuu weeeves", "ist wolkenmeer in diesem fall ein neologismus", "qrxvy (hund)", "batman", "five night freddy", "ich überlege", "gay lesson", "debug", "micheal","jackson","wendler bitter", "how to be GAYY!!", "trans learning", "gay recess", "crossdressing hour", "transgender lunch", "blm period"];
    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    Random random = Random();
    for(int day = 1; day < 8; day++){
      for(int i = 0; i < 6; i++){
        TimeOfDay startTime = TimeOfDay(hour: random.nextInt(24),minute: random.nextInt(59));
        TimeOfDay endTime = TimeOfDay(hour: random.nextInt(24),minute: random.nextInt(59));
        while(startTime.hour > endTime.hour || startTime.minute > endTime.minute){
           startTime = TimeOfDay(hour: random.nextInt(24),minute: random.nextInt(59));
           endTime = TimeOfDay(hour: random.nextInt(24),minute: random.nextInt(59));
        }
        TimeTable.addSubject(day, names[random.nextInt(names.length)], Colors.primaries[random.nextInt(Colors.primaries.length)],startTime ,endTime);
      }
      TimeTable.addSubject(day, weekDays[day-1], Colors.black, TimeOfDay(hour: 0,minute: 0), TimeOfDay(hour: 0,minute: 0));
      
      
    }


  }


}



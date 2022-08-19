import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperOptions{


  static void enterText(String? text){

    if(text == "" || text == null) return;

    switch(text.toLowerCase().replaceAll(RegExp(" "), "")){
      case "fortnite":
        Fortnite();
        break;
      case "sharkswimmingocean":
        SharkSwimmingOcean();
        break;
      case  "manuel":
        Manuel();
        break;
      case "sebastian":
        Sebastian();
        break;
    }

  }

  static void Fortnite(){

  }

  static void SharkSwimmingOcean(){

  }

  static void Manuel(){
    Uri url = Uri.parse("https://murmannmanuel.de/");
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  static void Sebastian(){

    TimeTable.saveEnabled = false;

    Subject("n",Colors.pink);
    Subject("a",Colors.pink);
    Subject("i",Colors.pink);
    Subject("t",Colors.pink);
    Subject("s",Colors.pink);
    Subject("a",Colors.pink);
    Subject("b",Colors.pink);
    Subject("e",Colors.pink);
    Subject("S",Colors.pink);

    for(int day = 1; day <= 5; day++){
      for(int lesson = 0; lesson < 9; lesson++){
        SubjectInstance(TimeTable.subjects[TimeTable.subjects.length - (lesson + 1)], day,lesson) ;
      }

    }


    for(Subject subject in TimeTable.subjects){
      DateTime? time = subject.getNextDate();
      if(time != null){
        if(time.year == DateTime.now().year && time.month == DateTime.now().month && time.day == DateTime.now().day){
          time = time.add(Duration(days: 7));
        }
        Homework(subject,time,"instagram: @sesegamer,twitter.com/cockman59627141,youtube: UwUGaming");
      }
    }

    TimeTable.saveEnabled = true;
    for(int i = 0; i < 100; i++){
      Event(DateTime(2005 + i,3,12),"Sebastian Geburtstag", "Er wird heute " + i.toString() + " Jahre Alt");

    }
    Event(DateTime(2005 + 100,3,12),"Sebastian Geburtstag", "Er wird heute sterben");


    BrainApp.notifier.notifyOfChanges();


  }

}
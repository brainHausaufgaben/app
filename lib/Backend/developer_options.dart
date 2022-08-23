import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperOptions{

  static List<String> activatedCodes = [];

  static Map<String,List<dynamic>> codes = {
    "fortnite" : [Fortnite, "Fortnite Gaming", "Macht Fortnite"],
    "sharkswimmingocean" : [SharkSwimmingOcean, "Shark Swimming Ocean", "Der Hai der schwimmt"],
    "manuel" : [Manuel, "Manuel", "Manuel hat das gemacht"],
    "sebastian" : [Sebastian, "Sebastian", "Sebastian hat das gemacht"],
    "ninja" : [Ninja, "Ninja", "Macht alles Unsichtbar"],
    "dunkelheit" : [Dunkelheit, "Dunkelheit", "Macht alles Schwarz"],
    "krebs" : [Cancer, "Schöner Modus", "Macht alles sehr schön :)"],
  };


  static void enterText(String? text){

    if(text == "" || text == null) return;

    List<dynamic>? result = codes[text.toLowerCase().trim()];

    if(result != null){
      Function function = result[0] as Function;
      function.call();
      if(!activatedCodes.contains(text)){
        activatedCodes.add(text);
        SaveSystem.saveDeveloperOptions();
      }
      BrainApp.notifier.notifyOfChanges();
    }

    /*
    switch(text.toLowerCase().trim()){
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
      case "ninja":
        Ninja();
        break;
      case "dunkelheit":
        Dunkelheit();
        break;
      case "krebs":
        Cancer();
        break;
      default:
        return;
    }
    */


  }


  static void Ninja() {
    AppDesign.setFromPackage(BlindnessDesign().darkVariant);
  }

  static void Dunkelheit() {
    AppDesign.setFromPackage(BlindnessDesign().lightVariant);

  }

  static void Doenerladen() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource("../images/notification_sounds.mp3"), mode: PlayerMode.mediaPlayer, volume: 1);
  }

  static void Fortnite(){

  }

  static void Cancer() async{
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(CancerDesign().darkVariant);
    });
    await Future.delayed(const Duration(milliseconds: 500));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(CancerDesign().lightVariant);
    });



  }



  static void SharkSwimmingOcean(){

  }

  static void Manuel() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(BlindnessDesign().darkVariant);
    });
    await Future.delayed(const Duration(milliseconds: 500));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppDesign.setFromPackage(MonochromeDesign().lightVariant);
    });
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
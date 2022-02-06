import 'dart:core';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

class Subject{
  String name = "";
  int day = 0;
  int lesson = 0;

  Color color = Colors.white;

  //Subject(this.name, this.startTime, this.endTime, this.color);
  Subject (this.name,this.day,this.lesson,this.color){
    TimeTable.addSubject(this);
  }

  String getStartTimeString(){
    String startTimeHour = TimeTable.lessons[lesson].startTime.hour.toString();
    String startTimeMinute = TimeTable.lessons[lesson].startTime.minute.toString();
    return ((startTimeHour.length == 1 ? "0" : "") + startTimeHour) + ":" + ((startTimeMinute.length == 1 ? "0" : "") + startTimeMinute);
  }



}
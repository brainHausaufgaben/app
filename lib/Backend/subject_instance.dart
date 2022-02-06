import 'dart:core';
import 'dart:math';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

class SubjectInstance{
  Subject subject;
  int day = 0;
  int lesson = 0;


  SubjectInstance (this.subject,this.day,this.lesson){
    TimeTable.addLesson(this);
  }

  String getStartTimeString(){
    String startTimeHour = TimeTable.lessonTimes[lesson].startTime.hour.toString();
    String startTimeMinute = TimeTable.lessonTimes[lesson].startTime.minute.toString();
    return ((startTimeHour.length == 1 ? "0" : "") + startTimeHour) + ":" + ((startTimeMinute.length == 1 ? "0" : "") + startTimeMinute);
  }

  DateTime getDate(){
    int day =  DateTime.now().weekday - this.day;
    if(DateTime.now().weekday > this.day) day = 7 - day;
    int hour = TimeTable.lessonTimes[lesson].startTime.hour;
    int minute = TimeTable.lessonTimes[lesson].startTime.minute;

    DateTime now = DateTime.now().subtract(Duration(hours: DateTime.now().hour,minutes: DateTime.now().minute,seconds: DateTime.now().second));
    DateTime time = now.add(Duration(days: day,hours: hour,minutes: minute));
    return time;
  }

  List<Homework> getHomework(){
    return TimeTable.getHomework(getDate(), subject);
  }



}
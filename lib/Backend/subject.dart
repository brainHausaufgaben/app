import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

class Subject{
  String name = "";
  Color color = Colors.white;

  //Subject(this.name, this.startTime, this.endTime, this.color);
  Subject (this.name,this.color){
    TimeTable.addSubject(this);
  }

  Subject.empty(){
    name = "Freistunde";
    color = Colors.grey;
  }


  TimeInterval? getTime(Day day){
    for(int i = 0; i < day.subjects.length; i++){
     if(day.subjects[i] != null) if(day.subjects[i]!.subject == this) return TimeTable.lessonTimes[i];
    }
  }

  DateTime? getNextDate(){
    int i = DateTime.now().weekday + 1;
    while(i != DateTime.now().weekday){
      for(SubjectInstance? subject in TimeTable.getDay(i).subjects){
        if(subject != null){
          if(subject.subject == this) return subject.getDate();
        }
      }
      i++;
      if(i > 7) i = 1;
    }
    for(SubjectInstance? subject in TimeTable.getDay(DateTime.now().weekday).subjects){
      if(subject != null){
        if(subject.subject == this) return subject.getDateFromDate(DateTime.now().add(const Duration(days:7)));
      }
    }


    return null;
  }




}
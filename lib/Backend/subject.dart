import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

class Subject{
  String name = "";
  Color color = Colors.white;

  //Subject(this.name, this.startTime, this.endTime, this.color);
  Subject (this.name,this.color){
    TimeTable.addSubject(this);
  }

  DateTime? getNextDate(){
    for(Day day in TimeTable.week){
      for(SubjectInstance? subject in day.subjects){
        if(subject != null){
          if(subject.subject == this) return subject.getDate();
        }
      }
    }
    return null;
  }




}
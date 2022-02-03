import 'dart:core';
import 'package:brain_app/Backend/subject.dart';
import 'package:flutter/material.dart';

class Day{
  List<Subject> subjects = [];

  void addSubject(String name, Color color, TimeOfDay startTime, TimeOfDay endTime){
      Subject subject = Subject(name,startTime,endTime,color);
      for(int i = 0; i < subjects.length; i++){
        if(subjects[i].startTime.hour > subject.startTime.hour){
          subjects.insert(i, subject);
          return;
        }
        else if(subjects[i].startTime.hour == subject.startTime.hour && subjects[i].startTime.minute > subject.startTime.minute){
          subjects.insert(i, subject);
          return;
        }
      }
      subjects.add(subject);
  }

}

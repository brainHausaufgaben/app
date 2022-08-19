import 'dart:core';

import 'package:brain_app/Backend/subject_instance.dart';

class Day{
  List<SubjectInstance?> subjects = [];

  Day(int length){
    subjects = List.filled(length, null);
  }

  void addSubject(SubjectInstance subject){
    subjects[subject.lesson] = subject;
  }

/*
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

 */



}

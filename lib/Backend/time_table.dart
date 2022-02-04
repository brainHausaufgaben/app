import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:flutter/material.dart';

class TimeTable{

  static List<Day> week = [];
  static List<TimeInterval> lessons = [
    TimeInterval(const TimeOfDay(hour: 8, minute: 00), const TimeOfDay(hour: 8, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 8, minute: 45), const TimeOfDay(hour: 9, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 9, minute: 45), const TimeOfDay(hour: 10, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 10, minute: 30), const TimeOfDay(hour: 11, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 11, minute: 15), const TimeOfDay(hour: 12, minute: 10)),
    TimeInterval(const TimeOfDay(hour: 12, minute: 10), const TimeOfDay(hour: 12, minute: 55)),
    TimeInterval(const TimeOfDay(hour: 13, minute: 50), const TimeOfDay(hour: 14, minute: 35)),
    TimeInterval(const TimeOfDay(hour: 12, minute: 35), const TimeOfDay(hour: 15, minute: 20)),
    TimeInterval(const TimeOfDay(hour: 15, minute: 35), const TimeOfDay(hour: 16, minute: 20)),
    TimeInterval(const TimeOfDay(hour: 16, minute: 20), const TimeOfDay(hour: 17, minute: 05)),
  ];


  static void addSubject(Subject subject){
    week[subject.day - 1].addSubject(subject);
  }

  static List<Subject> getSubjects(int day){
    List<Subject> subjects = [];
    for(Subject? subject in week[day-1].subjects){
      if(subject != null) {
        subjects.add(subject);
      }
    }
    return subjects;
  }

  static Day getDay(int day){
    return week[day-1];
  }

  static void init(){
    for(int i = 0;  i < 7; i++){
      week.add(Day(lessons.length));
    }
  }



}

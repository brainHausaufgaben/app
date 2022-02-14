import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class TimeTable {
  static List<Day> week = [];
  static List<Subject> subjects = [];
  static List<Homework> homeworks = [];
  static List<TimeInterval> lessonTimes = [
    TimeInterval(const TimeOfDay(hour: 8, minute: 00), const TimeOfDay(hour: 8, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 8, minute: 45), const TimeOfDay(hour: 9, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 9, minute: 45), const TimeOfDay(hour: 10, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 10, minute: 30), const TimeOfDay(hour: 11, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 11, minute: 15), const TimeOfDay(hour: 12, minute: 10)),
    TimeInterval(const TimeOfDay(hour: 12, minute: 10), const TimeOfDay(hour: 12, minute: 55)),
    TimeInterval(const TimeOfDay(hour: 13, minute: 50), const TimeOfDay(hour: 14, minute: 35)),
    TimeInterval(const TimeOfDay(hour: 14, minute: 35), const TimeOfDay(hour: 15, minute: 20)),
    TimeInterval(const TimeOfDay(hour: 15, minute: 35), const TimeOfDay(hour: 16, minute: 20)),
    TimeInterval(const TimeOfDay(hour: 16, minute: 20), const TimeOfDay(hour: 17, minute: 05)),
  ];
  static Subject emptySubject = Subject.empty();
  static State<MyApp>? app;

  static void addLesson(SubjectInstance subject){
    week[subject.day - 1].addSubject(subject);
  }
  static void addSubject(Subject subject){
    subjects.add(subject);
  }
  static void addHomework(Homework homework){
    homeworks.add(homework);
    app!.setState(() {});
  }
  static void removeHomework(Homework homework){
    if(homeworks.contains(homework))homeworks.remove(homework);
    app!.setState(() {});
  }


  static List<SubjectInstance> getSubjects(int day){
    List<SubjectInstance> subjects = [];
    for(SubjectInstance? subject in week[day-1].subjects){
      if(subject != null) {
        subjects.add(subject);
      }
    }
    return subjects;
  }

  static List<Homework> getHomework(DateTime date,Subject subject){
    List<Homework> homework = [];
    for(Homework hom in homeworks){
      if(hom.isDue(date) && hom.subject == subject){
        homework.add(hom);
      }
    }
    return homework;
  }

  static Day getDay(int day){
    return week[day-1];
  }

  static Day getDayFromDate(DateTime day){
    return week[day.weekday - 1];
  }

  static void init(State<MyApp> appl){
    for(int i = 0;  i < 7; i++){
      week.add(Day(lessonTimes.length));
    }
    app = appl;

  }



}

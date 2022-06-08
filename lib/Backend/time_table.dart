import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class TimeTable {
  static List<Day> week = [];
  static List<Subject> subjects = [];
  static List<Homework> homeworks = [];
  static List<Event> events = [];
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
  static bool saveEnabled = false;
  static Subject emptySubject = Subject.empty();

  static void addLesson(SubjectInstance subject){
    week[subject.day - 1].addSubject(subject);
    if(saveEnabled) SaveSystem.saveTimeTable();
  }
  static void addSubject(Subject subject){
    subjects.add(subject);
    if(saveEnabled) SaveSystem.saveSubjects();
  }
  static void deleteSubject(Subject subject){
    subjects.remove(subject);
    for(Homework homework in getHomeworks(subject)){
      removeHomework(homework);
    }
    deleteSubjectInstances(subject);
  }
  static void deleteSubjectInstances(Subject subject){
    //keine ahnung ob diese geht xD
    for(int i = 0; i < week.length; i++){
      for(int j = 0; j < lessonTimes.length; j++){
        if(week[i].subjects[j] != null){
          if(week[i].subjects[j]!.subject == subject){
            week[i].subjects[j] == null;
          }
        }
      }
    }

  }

  static void addHomework(Homework homework){
    homeworks.add(homework);
    BrainApp.notifier.notifyOfChanges();
    if(saveEnabled) SaveSystem.saveHomework();
    CustomNotifications.presistentNotification();
  }
  static void addEvent(Event event){
    events.add(event);
  }
  static void removeEvent(Event event){
    if(events.contains(event))events.remove(event);
  }
  static void removeHomework(Homework homework){
    if(homeworks.contains(homework))homeworks.remove(homework);
    BrainApp.notifier.notifyOfChanges();
    if(saveEnabled) SaveSystem.saveHomework();
    CustomNotifications.presistentNotification();
  }

  static Subject ?getSubject(int id){
    for(Subject subject in subjects){
      if(subject.id == id) return subject;
    }
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

  static List<Homework> getHomeworks(Subject subject){
    List<Homework> hw = [];
    for(Homework homework in homeworks){
      if(homework.subject == subject) hw.add(homework);
    }
    return hw;
  }

  static List<SubjectInstance> getSubjectInstancesByDate(DateTime date){
    return getSubjects(date.weekday);
  }

  static List<Subject> getSubjectsByDate(DateTime date){
    List<SubjectInstance> subjectInstances = getSubjectInstancesByDate(date);
    return subjectInstances.map((subjectInstance) {
      return subjectInstance.subject;
    }).toList();

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

  static void init(){
    for(int i = 0;  i < 7; i++){
      week.add(Day(lessonTimes.length));
    }
  }
  static List subjectsToJSONEncodeble(){
     return subjects.map((item)
       {
         return item.toJSONEncodable();
       }
     ).toList();

  }
  static List timeTableToJSONEncodable(){
    List days = [];
    for(Day day in week){
      List subjects = [];
      for(int i = 0; i < day.subjects.length; i++){
        SubjectInstance? subject = day.subjects[i];
        if(subject != null) {
          subjects.add(subject.subject.id);
        } else {
          subjects.add(0);
        }

      }
      days.add(subjects);
    }
    return days;

  }

  static List homeworkToJSONEncodable(){
    return homeworks.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();

  }





}

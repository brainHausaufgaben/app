import 'dart:core';

import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class TimeTable {
  static List<Day> week = [];
  static List<Subject> subjects = [];
  static List<LinkedSubject> linkedSubjects = [];
  static List<Subject> noAverageSubjects = [];
  static List<Homework> homeworks = [];
  static List<Homework> deletedHomeworks = [];
  static List<Event> events = [];
  static List<Test> tests = [];
  static List<Note> notes = [];
  static List<TimeInterval> lessonTimes = [
    TimeInterval(const TimeOfDay(hour: 8, minute: 00), const TimeOfDay(hour: 8, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 8, minute: 45), const TimeOfDay(hour: 9, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 9, minute: 45), const TimeOfDay(hour: 10, minute: 30)),
    TimeInterval(const TimeOfDay(hour: 10, minute: 30), const TimeOfDay(hour: 11, minute: 45)),
    TimeInterval(const TimeOfDay(hour: 11, minute: 25), const TimeOfDay(hour: 12, minute: 10)),
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
  static void addLinkedSubject(LinkedSubject subject){
    for(Subject s in subject.subjects){
      if(noAverageSubjects.contains(s)) return;
      noAverageSubjects.add(s);
    }
    linkedSubjects.add(subject);
    if(saveEnabled) SaveSystem.saveLinkedSubjects();

  }

  static void deleteLinkedSubject(LinkedSubject linkedSubject){
    linkedSubjects.remove(linkedSubject);

    for (Subject subject in linkedSubject.subjects) {
      noAverageSubjects.remove(subject);
    }

    if(saveEnabled) SaveSystem.saveLinkedSubjects();
  }

  static LinkedSubject? getLinkedSubject(Subject subject){
    for(LinkedSubject s in linkedSubjects){
      if(s.subjects.contains(subject))return s;
    }
    return null;

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
    GradingSystem.deleteSubject(subject);
    if(getLinkedSubject(subject) != null) deleteLinkedSubject(getLinkedSubject(subject)!);
    if(saveEnabled) SaveSystem.saveSubjects();
  }
  static void deleteSubjectInstances(Subject subject){
    //keine ahnung ob diese geht xD
    for(int i = 0; i < week.length; i++){
      for(int j = 0; j < lessonTimes.length; j++){
        if(week[i].subjects[j] != null){
          if(week[i].subjects[j]!.subject == subject){
            week[i].subjects[j] = null;
          }
        }
      }
    }
  }

  static void addHomework(Homework homework){
    homeworks.add(homework);
    BrainApp.notifier.notifyOfChanges();
    if(saveEnabled) SaveSystem.saveHomework();
    CustomNotifications.persistentNotification() ;
    CustomNotifications.homeworkNotification(homework);
  }

  static void addEvent(Event event){
    events.add(event);
    SaveSystem.saveEvents();
  }

  static void removeEvent(Event event){
    if(events.contains(event))events.remove(event);
    SaveSystem.saveEvents();
  }

  static void addNote(Note note){
    notes.add(note);
    SaveSystem.saveEvents();
  }

  static void removeNote(Note note){
    if(notes.contains(note))notes.remove(note);
    SaveSystem.saveEvents();
  }

  static List<Note> getNotes(DateTime date){
    List<Note> output = [];
    for(Note note in notes){
      if(note.isDue(date) ){
        output.add(note);
      }
    }
    return output;
  }

  static List<Test> getTests(DateTime day) {
    List<Test> _tests = [];

    for (Test test in tests) {
      if (test.isDue(day)) {
        _tests.add(test);
      }
    }

    return _tests;
  }

  static void addTest(Test test){
    tests.add(test);
    CustomNotifications.testNotification(test);
    SaveSystem.saveTests();
  }

  static void removeTest(Test test){
    if(tests.contains(test))tests.remove(test);
    SaveSystem.saveTests();
    CustomNotifications.notificationsPlugin.cancel(test.notificationID);
  }


  static void removeHomework(Homework homework){
    if(homeworks.contains(homework)){
      homeworks.remove(homework);
      deletedHomeworks.insert(0,homework);
    }
    BrainApp.notifier.notifyOfChanges();
    if(saveEnabled) SaveSystem.saveHomework();
    CustomNotifications.persistentNotification();
    CustomNotifications.notificationsPlugin.cancel(homework.notificationID);
  }

  static void reinstateHomework(Homework homework){
    if(deletedHomeworks.contains(homework))deletedHomeworks.remove(homework);
    addHomework(homework);
  }

  static void reinstateLastHomework(){
    if(deletedHomeworks.isNotEmpty)reinstateHomework(deletedHomeworks[0]);
  }


  static Subject? getSubject(int id){
    for(Subject subject in subjects){
      if(subject.id == id) return subject;
    }
    return null;
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

  static List<Subject> getAverageSubject(){
    List<Subject> out = [];
    for(Subject s in subjects){
      if(!noAverageSubjects.contains(s))out.add(s);
    }
    return out;

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

  static List<Event> getEvents(DateTime date){
    List<Event> event = [];
    for(Event ev in events){
      if(ev.isDue(date) ){
        event.add(ev);
      }
    }
    return event;
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

  static List lessonTimesToJSONEncodable(){
    List out = [];
    for(int i = 0; i < lessonTimes.length;i++){
      TimeInterval lesson =  lessonTimes[i];
      List<List> time = [[lesson.startTime.hour,lesson.startTime.minute],[lesson.endTime.hour,lesson.endTime.minute]];
      out.add(time);

    }
    return out;
  }

  static List homeworkToJSONEncodable(){
    return homeworks.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();

  }
  static List eventsToJSONEncodable(){

    List out = [];
    for(Event event in events){
      out.add(event.toJSONEncodable());
    }
    for(Note note in notes){
      out.add(note.toJSONEncodable());
    }
    return out;
  }

  static List testsToJSONEncodable(){
    return tests.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();

  }
  static List linkedSubjectsToJSONEncodable(){
    return linkedSubjects.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();

  }




}

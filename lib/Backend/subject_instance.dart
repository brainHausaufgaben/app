import 'dart:core';

import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class SubjectInstance{
  late Subject subject;
  int day = 0;
  int lesson = 0;


  SubjectInstance (this.subject,this.day,this.lesson){
    TimeTable.addLesson(this);
  }

  SubjectInstance.empty(this.lesson){
    subject = TimeTable.emptySubject;
  }

  String getStartTimeString(){
    String startTimeHour = TimeTable.lessonTimes[lesson].startTime.hour.toString();
    String startTimeMinute = TimeTable.lessonTimes[lesson].startTime.minute.toString();
    return "${startTimeHour.padLeft(2, "0")}:${startTimeMinute.padLeft(2, "0")}";
  }

  String getEndTimeString(){
    String endTimeHour = TimeTable.lessonTimes[lesson].endTime.hour.toString();
    String endTimeMinute = TimeTable.lessonTimes[lesson].endTime.minute.toString();
    return "${endTimeHour.padLeft(2, "0")}:${endTimeMinute.padLeft(2, "0")}";
  }

  //returns the date of the current week
  DateTime getDate(){
    int day = this.day - DateTime.now().weekday;
    if(DateTime.now().weekday > this.day) day += 7;
    int hour = TimeTable.lessonTimes[lesson].startTime.hour;
    int minute = TimeTable.lessonTimes[lesson].startTime.minute;
    DateTime now = DateTime.now().subtract(Duration(hours: DateTime.now().hour,minutes: DateTime.now().minute,seconds: DateTime.now().second));
    DateTime time = now.add(Duration(days: day,hours: hour,minutes: minute));
    return time;
  }
  DateTime getDateFromDate(DateTime date){
    int hour = TimeTable.lessonTimes[lesson].startTime.hour;
    int minute = TimeTable.lessonTimes[lesson].startTime.minute;
    return(DateTime(date.year,date.month,date.year,hour,minute));
  }

  List<Homework> getHomework(){
    return TimeTable.getHomework(getDate(), subject);
  }
}
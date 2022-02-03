import 'dart:core';
import 'package:brain_app/Backend/day.dart';
import 'package:flutter/material.dart';

class TimeTable{

  static List<Day> week = [];

  static void addSubject(int day, String name, Color color, TimeOfDay startTime, TimeOfDay endTime){
    week[day - 1].addSubject(name, color, startTime, endTime);
  }

  static Day getDay(int day){
    return week[day-1];
  }

  static init(){
    for(int i = 0;  i < 7; i++){
      week.add(Day());
    }
  }



}

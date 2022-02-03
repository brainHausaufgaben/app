import 'dart:core';
import 'package:flutter/material.dart';

class Subject{
  String name = "";
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  Color color = Colors.white;

  Subject(this.name, this.startTime, this.endTime, this.color);

  String getStartTimeString(){
    return startTime.hour.toString()  + ":" + startTime.minute.toString();

  }

}
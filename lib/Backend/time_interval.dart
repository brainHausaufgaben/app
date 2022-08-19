import 'dart:core';

import 'package:flutter/material.dart';

class TimeInterval{
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  TimeInterval(this.startTime,this.endTime);

  bool isDuring(TimeOfDay time){
    if(time.hour > startTime.hour && time.hour < endTime.hour) {
      return true;
    } else if(time.hour == startTime.hour && time.minute > startTime.minute &&  time.minute < endTime.minute) {
      return true;
    } else if(time.hour == endTime.hour && time.minute < endTime.minute) {
      return true;
    } else {
      return false;
    }
  }


}
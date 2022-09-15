import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import 'box.dart';
import 'brain_dismissible.dart';


class HomePageDay extends StatefulWidget {
  HomePageDay({Key? key, required this.day, required this.headline}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>  _HomePageDay();

  List<Subject> subjectsOccurred = [];
  final int day;
  final String headline;

  List<Widget> getHomework(SubjectInstance subject){
    List<Widget> homeworkWidgets = [];
    if(subjectsOccurred.contains(subject.subject)) {
      return homeworkWidgets;
    } else {
      subjectsOccurred.add(subject.subject);
    }
    for(Homework homework in subject.getHomework()){
      homeworkWidgets.add(
          BrainDismissible(homework: homework)
      );
    }
    return homeworkWidgets;
  }


  List<Widget> getWidgets(){
    List<SubjectInstance> subjects = [];
    List<Widget> subjectWidgets = [];
    bool fill = false;
    for(int i = 9; i >= 0; i--){
      if(!fill){
        if(TimeTable.week[day-1].subjects[i] != null){
          fill = true;
          i++;
        }
      }
      else{
        if(TimeTable.week[day-1].subjects[i] == null) {
          subjects.insert(0, SubjectInstance.empty(i));
        } else {
          subjects.insert(0, TimeTable.week[day-1].subjects[i]!);

        }
      }
    }

    for(SubjectInstance subject in subjects){
      List<Widget> homework = getHomework(subject);

      if (subject.lesson == 6) {
        subjectWidgets.add(
          const Text("...")
        );
      }

      subjectWidgets.add(
          PointElement(
              color: subject.subject.color,
              primaryText: subject.subject.name,
              secondaryText: "${subject.getStartTimeString()} ${BrainApp.preferences["showLessonEndTimes"] ? " - ${subject.getEndTimeString()}" : ""}",
              child: homework.isEmpty ? null : Wrap(
                runSpacing: 3,
                children: homework
              )
          )
      );
    }
    return subjectWidgets;
  }
}

class _HomePageDay extends  State<HomePageDay>{
  @override
  Widget build(BuildContext context){
    widget.subjectsOccurred = [];
    return Box(
        headline: widget.headline,
        child: Wrap(
          runSpacing: 10,
          children: widget.getWidgets(),
        )
    );
  }
}



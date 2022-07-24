import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'brain_dismissible.dart';

import 'box.dart';


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
    List<SubjectInstance> subjects = TimeTable.getSubjects(day);
    List<Widget> subjectWidgets = [];
    for(SubjectInstance subject in subjects){
      List<Widget> homework = getHomework(subject);

      subjectWidgets.add(
          PointElement(
              color: subject.subject.color,
              primaryText: subject.subject.name,
              secondaryText: subject.getStartTimeString(),
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



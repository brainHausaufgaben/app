import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';

import '../Box.dart';


class HomePageDay extends StatefulWidget {
  HomePageDay({Key? key, required this.day, required this.headline}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>  _HomePageDay();

  int day;
  String headline;

  List<Widget> getWidgets(){
    List<Subject> subjects = TimeTable.getSubjects(day);
    List<Widget> subjectWidgets = [];
    for(Subject subject in subjects){
      subjectWidgets.add(
        Padding(
            padding:const EdgeInsets.only(bottom: 8),
            child:PointElement(color: subject.color,primaryText: subject.name,secondaryText: subject.getStartTimeString())
        )
      );
    }
    return subjectWidgets;
  }

}

class _HomePageDay extends  State<HomePageDay>{
  @override
  Widget build(BuildContext context){
    return  Box(
        headline: widget.headline,
        child: Column(
            children: widget.getWidgets(),
          )
    );


  }

}



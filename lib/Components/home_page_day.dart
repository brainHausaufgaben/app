import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'dismissable_box.dart';

import 'box.dart';


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
          PointElement(color: subject.color,primaryText: subject.name,secondaryText: subject.getStartTimeString(), child: DismissableBox())
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
        // Mit wrap kann man besser spacing zwischen den kindern machen
        child: Wrap(
          runSpacing: 10,
          children: widget.getWidgets(),
        )
    );


  }

}



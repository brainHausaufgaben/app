import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Box.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'page_template.dart';
import '../Components/warning_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePage();



}
class _HomePage extends State<HomePage>{

  List<int> getDayIndexes(){
    List<int> dayIndexes =  [];
    int currentDay = DateTime.now().weekday;
    int day = currentDay;

    while(true){
      if(day == 6)day = 1;
      dayIndexes.add(day);
      day++;
      if(day == currentDay)return dayIndexes;
    }
  }

  List<Widget> getDays(){

    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];



    List<Widget> days = [];
    List<int> dayIndexes = getDayIndexes();
    for(int i = 0; i < dayIndexes.length; i++){
      String headline = weekDays[dayIndexes[i] - 1];
      if(dayIndexes[i] == DateTime.now().weekday) headline = "Stundenplan Heute";
      if(dayIndexes[i] == DateTime.now().weekday + 1) headline = "Stundenplan Morgen";
      days.add(HomePageDay(day: dayIndexes[i], headline: headline,));

    }
    return days;
  }


  @override
  Widget build(BuildContext context) {

    return
      PageTemplate(
        title: 'Übersicht',
        child:
        Expanded( child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WarningBox(
                text: "Du hast noch unerledigte Hausaufgaben in 2 Fächern",
                iconIndex: 0
            ),
            Flexible(child:
            ListView(
                 scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: getDays(),
              ),
            )
          ],
        )
    )
      );
  }

}

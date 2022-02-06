import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
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

  List<int> getDayIndices(){
    List<int> dayIndices =  [];
    int currentDay = DateTime.now().weekday;
    int day = currentDay;

    for (int i=1; i<=5; i++) {
      if (day >= 6) day = 1;
      dayIndices.add(day);
      day++;
    }

    return dayIndices;
  }

  List<Widget> getDays(){

    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];



    List<Widget> days = [];
    List<int> dayIndexes = getDayIndices();
    for(int i = 0; i < dayIndexes.length; i++){
      String headline = weekDays[dayIndexes[i] - 1];
      if(dayIndexes[i] == DateTime.now().weekday) headline = "Stundenplan Heute";
      if(dayIndexes[i] == DateTime.now().weekday + 1) headline = "Stundenplan Morgen";
      days.add(HomePageDay(day: dayIndexes[i], headline: headline,));

    }
    return days;
  }

  Widget getWarningBox(){
      int homework = TimeTable.homeworks.length;
      int iconIndex = 0;
      DateTime nextHomework = DateTime(99999);
      for(Homework hom in TimeTable.homeworks){
        if(nextHomework.isAfter(hom.dueTime)) nextHomework = hom.dueTime;
      }
      if(homework == 0) {
        iconIndex = 2;
      } else if(nextHomework.day == DateTime.now().day && nextHomework.month == DateTime.now().month) {
        iconIndex = 0;
      }else {
        iconIndex = 1;
      }
      String text = "";

      if(iconIndex == 2)text = "Du hast schon alle Hausaufgaben erledigt";
      if(iconIndex == 1 || iconIndex ==  0) text = "Du hast noch " + homework.toString() + " unerledigte Hausaufgaben";

      return WarningBox(text: text, iconIndex: iconIndex);
  }


  @override
  Widget build(BuildContext context) {
    //if(DateTime.now().weekday == 7) return Text("heute ist sonntag geh in kirche");
    return PageTemplate(
        title: 'Übersicht',
        child: Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           getWarningBox(),
            Flexible(child:
              ListView(
                  padding: EdgeInsets.only(top:20),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: getDays(),
                ),
            ),
          ],
        )
    )
      );
  }

}

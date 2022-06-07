import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Pages/homework_page.dart';
import 'package:brain_app/Pages/settings.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'page_template.dart';
import 'package:brain_app/Components/collapsible_box.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}): super(key: key);

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
      List<IconData> icons = [Icons.warning_rounded, Icons.warning_rounded, Icons.check_circle_rounded];
      List<Color> iconColors = [Colors.red, Colors.orange, Colors.green];
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
      if(iconIndex == 1 || iconIndex ==  0) text = "Du hast noch " + homework.toString() + " unerledigte Hausaufgabe" + (homework == 1 ? "" : "n");

      return CollapsibleBox(text: text, icon: icons[iconIndex], iconColor: iconColors[iconIndex], dark: true);
  }

  @override
  Widget build(BuildContext context) {
    //if(DateTime.now().weekday == 7) return Text("heute ist sonntag geh in kirche");
    return PageTemplate(
      title: 'Übersicht',
      floatingActionButton: CustomMenuButton(
        icon: const Icon(Icons.add),
        menuEntries: [
          SpeedDialChild(
            backgroundColor: AppDesign.current.primaryColor,
            foregroundColor: AppDesign.current.textStyles.contrastColor,
            labelBackgroundColor: AppDesign.current.primaryColor,
            labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
            label: "Hausaufgaben",
            child: const Icon(Icons.description_rounded),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeworkPage())
              );
            }
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getWarningBox(),
          if (SettingsPage.mediaBox) Padding(
            padding: const EdgeInsets.only(top: 7),
            child: CollapsibleBox(
                text: BrainApp.boxText,
                icon: BrainApp.icon,
                dark: true
            ),
          ),
          Expanded(
            child: ListView(
                padding: const EdgeInsets.only(top:25),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: getDays()
            ),
          ),
        ],
      )
    );
  }
}
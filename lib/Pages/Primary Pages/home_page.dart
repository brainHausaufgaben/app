import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import '../../Components/box.dart';
import '../page_template.dart';
import 'package:brain_app/Components/collapsible_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

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
      if(TimeTable.getSubjects(dayIndexes[i]).isNotEmpty) days.add(HomePageDay(day: dayIndexes[i], headline: headline,));
    }

    if (days.isEmpty) {
      return [
        Box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_box_outlined, size: 40),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Icon(Icons.add_box_rounded, size: 40)
                  ),
                  Icon(Icons.add_box_outlined, size: 40)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  "Dein Stundenplan ist noch leer",
                  style: AppDesign.current.textStyles.boxHeadline.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppDesign.current.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13)
                      ),
                      onPressed: () {
                        NavigationHelper.pushNamed("/settings/timetable");
                      },
                      child: Text("Stundenplan", style: AppDesign.current.textStyles.buttonText),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppDesign.current.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13)
                        ),
                        onPressed: () {
                          NavigationHelper.pushNamed("/settings/timetable/subjectPage");
                        },
                        child: Text("Neues Fach", style: AppDesign.current.textStyles.buttonText),
                      ),
                    ),
                  )
                ],
              )
            ]
          )
        )
      ];
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

      return CollapsibleBox(
        text: text,
        icon: icons[iconIndex],
        iconColor: iconColors[iconIndex],
        collapsed: BrainApp.preferences["warningBoxCollapsed"],
        onTap: () {
          setState(() {
            BrainApp.updatePreference("warningBoxCollapsed", !BrainApp.preferences["warningBoxCollapsed"]);
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    //if(DateTime.now().weekday == 7) return Text("heute ist sonntag geh in kirche");
    return PageTemplate(
      title: 'Übersicht',
      floatingActionButton: BrainMenuButton(
        defaultAction: () => NavigationHelper.pushNamed("/homeworkPage"),
        defaultLabel: "Neu",
      ),
      child: Wrap(
        runSpacing: 20,
        children: getDays(),
      ),
      floatingHeader: Wrap(
        runSpacing: 5,
        children: [
          getWarningBox(),
          if (BrainApp.preferences["showMediaBox"]) CollapsibleBox(
            text: BrainApp.todaysJoke,
            icon: BrainApp.icon,
            collapsed: BrainApp.preferences["mediaBoxCollapsed"],
            onTap: () {
              setState(() {
                BrainApp.updatePreference("mediaBoxCollapsed", !BrainApp.preferences["mediaBoxCollapsed"]);
              });
            }
          )
        ]
      )
    );
  }
}
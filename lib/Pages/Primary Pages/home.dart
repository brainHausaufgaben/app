import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_infobox.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

import '../../Components/box.dart';
import '../page_template.dart';

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
                children: [
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.current.textStyles.color),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Icon(Icons.add_box_rounded, size: 40, color: AppDesign.current.textStyles.color)
                  ),
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.current.textStyles.color)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  "Dein Stundenplan ist noch leer",
                  style: AppDesign.current.textStyles.boxHeadline.copyWith(fontSize: 20),
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
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14)
                      ),
                      onPressed: () => NavigationHelper.pushNamed(context, "timeTable"),
                      child: Text("Stundenplan", style: AppDesign.current.textStyles.buttonText.copyWith(fontSize: 16)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppDesign.current.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14)
                        ),
                        onPressed: () => NavigationHelper.pushNamed(context, "subjectPage"),
                        child: Text("Neues Fach", style: AppDesign.current.textStyles.buttonText.copyWith(fontSize: 16)),
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

  Widget getHeader(){
      int homework = TimeTable.homeworks.length;

      DateTime nextHomework = DateTime(99999);
      for(Homework hom in TimeTable.homeworks){
        if(nextHomework.isAfter(hom.dueTime)) nextHomework = hom.dueTime;
      }

      int eventsCount = TimeTable.getEvents(DateTime.now()).length;
      IconData eventsIcon;
      String eventsText = "";
      if (eventsCount > 0) {
        eventsIcon = Icons.warning_rounded;
        eventsText = "Du hast heute noch ${eventsCount.toString()} Termin${eventsCount == 1 ? "" : "e"}!";
      } else {
        eventsIcon = Icons.check_circle_rounded;
        eventsText = "Du hast heute keine Termine";
      }

      IconData homeworkIcon = Icons.check_circle_rounded;
      String homeworkText = "Du hast schon alle Hausaufgaben erledigt";
      if(homework > 0) {
        homeworkIcon = Icons.warning_rounded;
        homeworkText = "Du hast noch ${homework.toString()} unerledigte Hausaufgabe${homework == 1 ? "" : "n"}!";
      }

      return NotificationListener<OverscrollNotification> (
        onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            children: [
              BrainInfobox(
                isPrimary: true,
                title: homeworkText,
                shortDescription: "Hausaufgaben",
                icon: homeworkIcon,
              ),
              BrainInfobox(
                title: eventsText,
                shortDescription: "Termine",
                icon: eventsIcon,
                action: () {
                  CalendarPage.selectedDay = DateTime.now();
                  NavigationHelper.selectedPrimaryPage.value = 2;
                  NavigationHelper.pushNamedReplacement(context, "calendar");
                },
              ),
              if (BrainApp.preferences["showMediaBox"] && BrainApp.todaysMedia != null) BrainInfobox(
                  title: BrainApp.todaysMedia!.content,
                  shortDescription: BrainApp.todaysMedia!.type,
                  icon: BrainApp.todaysMedia!.icon
              )
            ],
          ),
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.primaryVelocity! > 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 0;
            NavigationHelper.pushNamedReplacement(context, "gradesOverview");
          } else {
            NavigationHelper.selectedPrimaryPage.value = 2;
            NavigationHelper.pushNamedReplacement(context, "calendar");
          }
        }
      },
      child: PageTemplate(
        title: 'Übersicht',
        floatingActionButton: BrainMenuButton(
          defaultAction: () => NavigationHelper.pushNamed(context, "homework"),
          defaultLabel: "Neu",
        ),
        child: Wrap(
          runSpacing: 20,
          children: [
            if (!BrainApp.preferences["pinnedHeader"]) getHeader(),
            ...getDays()
          ],
        ),
        floatingHeader: BrainApp.preferences["pinnedHeader"] ? getHeader() : null
      ),
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/export_import_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/initializer.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/brain_confirmation_dialog.dart';
import 'package:brain_app/Components/brain_infobox.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  static int timesRun = 0;

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
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.colors.text),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Icon(Icons.add_box_rounded, size: 40, color: AppDesign.colors.text)
                  ),
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.colors.text)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Dein Stundenplan ist noch leer",
                  style: AppDesign.textStyles.boxHeadline.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Füge ein neues Fach hinzu oder fülle deinen Stundenplan aus :)",
                  textAlign: TextAlign.center,
                  style: AppDesign.textStyles.pointElementSecondary,
                )
              ),
              Flex(
                crossAxisAlignment: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
                    ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
                direction: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
                    ? Axis.horizontal : Axis.vertical,
                children: getButtons(MediaQuery.of(context).size.width > AppDesign.breakPointWidth)
              )
            ]
          )
        )
      ];
    }

    return days;
  }

  List<Widget> getButtons(bool asRow) {
    Widget button1 = TextButton(
      style: TextButton.styleFrom(
          foregroundColor: AppDesign.colors.contrast,
          backgroundColor: AppDesign.colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13)
      ),
      onPressed: () => NavigationHelper.pushNamed(context, "timeTable"),
      child: Text("Stundenplan", style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)),
    );
    Widget button2 = Padding(
        padding: asRow
            ? const EdgeInsets.only(left: 10)
            : const EdgeInsets.only(top: 5),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppDesign.colors.text,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            side: BorderSide(color: AppDesign.colors.text, width: 2.0)
          ),
          onPressed: () => NavigationHelper.pushNamed(context, "subjectPage"),
          child: Text("Neues Fach", style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16, color: AppDesign.colors.text)),
        )
    );

    return [
      asRow ? Expanded(
        child: button1,
      ) : button1,
      asRow ? Expanded(
        child: button2,
      ) : button2
    ];
  }

  Widget getHeader(){
      int homework = TimeTable.homeworks.length;

      DateTime firstHomework = DateTime(99999);
      for(Homework hom in TimeTable.homeworks){
        if(firstHomework.isAfter(hom.dueTime)) firstHomework = hom.dueTime;
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
                        action: homework == 0 ? null : () {
                          CalendarPage.selectedDay = firstHomework;
                          NavigationHelper.selectedPrimaryPage.value = 2;
                          NavigationHelper.pushNamedReplacement(context, "calendar");
                        }
                    ),
                    BrainInfobox(
                        title: eventsText,
                        shortDescription: "Termine",
                        icon: eventsIcon,
                        action: () {
                          CalendarPage.selectedDay = DateTime.now();
                          NavigationHelper.selectedPrimaryPage.value = 2;
                          NavigationHelper.pushNamedReplacement(context, "calendar");
                        }
                    ),
                    if (BrainApp.preferences["showMediaBox"] && BrainApp.todaysMedia != null) BrainInfobox(
                        title: BrainApp.todaysMedia!.content,
                        shortDescription: BrainApp.todaysMedia!.type,
                        icon: BrainApp.todaysMedia!.icon
                    )
                  ]
              )
          )
      );
  }

  List<Widget> staggeredChildren() {
    if (HomePage.timesRun <= 1) {
      HomePage.timesRun++;
      return AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (child) => SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(
                child: child,
              )
          ),
          children: getDays()
      );
    } else {
      return getDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 0;
            NavigationHelper.pushNamedReplacement(context, "gradesOverview");
          } else if (details.velocity.pixelsPerSecond.dx < 0.0) {
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
          children: Initializer.initialized
            ? staggeredChildren()
            : []
        ),
        floatingHeader: getHeader()
      ),
    );
  }
}
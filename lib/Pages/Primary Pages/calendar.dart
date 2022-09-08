import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/brain_dismissible.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}): super(key: key);

  static DateTime selectedDay = DateTime.now();

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  List<Widget> getSelectedEvents() {
    List<Widget> boxes = [];
    List<Event> events = TimeTable.getEvents(CalendarPage.selectedDay);
    for (int i=0; i<events.length; i++) {
      boxes.add(
          BrainIconButton(
            dense: true,
            action: () => NavigationHelper.pushNamed(context, "editEventsPage", payload: events[i]),
            icon: Icons.edit,
            child: PointElement(
              color: AppDesign.colors.primary,
              primaryText: events[i].name,
              child: events[i].description.isEmpty ? null : Text(events[i].description, style: AppDesign.textStyles.pointElementSecondary),
            )
          )
      );
    }

    return boxes;
  }

  List<Widget> getSelectedTests() {
    List<Widget> boxes = [];
    List<Test> tests = TimeTable.getTests(CalendarPage.selectedDay);

    for (int i=0; i<tests.length; i++) {
      boxes.add(
        BrainIconButton(
          action: () => NavigationHelper.pushNamed(context, "editTestPage", payload: tests[i]),
          icon: Icons.edit,
          dense: true,
          child: PointElement(
            color: tests[i].subject.color,
            primaryText: tests[i].subject.name,
            child: Text(tests[i].description,
              style: AppDesign.textStyles.pointElementSecondary),
          )
        )
      );
    }

    return boxes;
  }

  List<Widget> getSelectedHomework() {
    List<Widget> boxes = [];

    for (Subject subject in TimeTable.subjects) {
      List<Homework> homework = TimeTable.getHomework(CalendarPage.selectedDay, subject);
      List<BrainDismissible> dismissableBoxes = [];

      for (Homework _homework in homework) {
        dismissableBoxes.add(
          BrainDismissible(homework: _homework)
        );
      }

      if (dismissableBoxes.isNotEmpty) {
        boxes.add(
            Box(
              child: PointElement(
                  color: subject.color,
                  primaryText: subject.name,
                  child: Column(
                    children: dismissableBoxes,
                  )
              ),
            )
        );
      }
    }

    return boxes;
  }

  List<Homework> getHomeworkByDay(DateTime day) {
    List<Homework> homework = [];

    for (Subject subject in TimeTable.subjects) {
      homework.addAll(TimeTable.getHomework(day, subject));
    }

    return homework;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 1;
            NavigationHelper.pushNamedReplacement(context, "home");
          }
        }
      },
      child: PageTemplate(
          title: "Kalender",
          floatingActionButton: BrainMenuButton(
            defaultAction: () => NavigationHelper.pushNamed(context, "addEventPage"),
            defaultLabel: "Neu",
          ),
          child: Wrap(
              runSpacing: 20,
              children: [
                Box(
                    child: TableCalendar(
                        calendarFormat: CalendarFormat.values[BrainApp.preferences["calendarFormat"]],
                        availableCalendarFormats: const {
                          CalendarFormat.month : "Monat",
                          CalendarFormat.week : "Woche",
                          CalendarFormat.twoWeeks : "2 Wochen"
                        },
                        locale: "de_DE",
                        firstDay: DateTime.utc(2018, 10, 16),
                        lastDay: DateTime.now().add(const Duration(days:730)),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        focusedDay: CalendarPage.selectedDay,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(color: AppDesign.colors.text),
                          weekendTextStyle: TextStyle(color: AppDesign.colors.text),
                          outsideTextStyle: TextStyle(color: AppDesign.colors.text05),
                          todayDecoration: BoxDecoration(color: AppDesign.colors.background, shape: BoxShape.circle),
                          todayTextStyle: TextStyle(color: AppDesign.colors.text),
                          selectedDecoration: BoxDecoration(color: AppDesign.colors.primary, shape: BoxShape.circle),
                          selectedTextStyle: TextStyle(color: AppDesign.colors.contrast),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: AppDesign.colors.text),
                            weekendStyle: TextStyle(color: AppDesign.colors.text)
                        ),
                        headerStyle: HeaderStyle(
                          headerPadding: const EdgeInsets.only(bottom: 10),
                          titleTextStyle: TextStyle(color: AppDesign.colors.text, fontSize: 18, fontWeight: FontWeight.w600),
                          titleCentered: true,
                          formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppDesign.colors.text)
                          ),
                          formatButtonTextStyle: TextStyle(color: AppDesign.colors.text),
                          leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.colors.text),
                          rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.colors.text),
                        ),
                        calendarBuilders: CalendarBuilders(
                          singleMarkerBuilder: (context, date, event) {
                            Color color = Colors.deepOrange;
                            BoxShape shape = BoxShape.circle;
                            switch (event.runtimeType) {
                              case Event:
                                shape = BoxShape.rectangle;
                                color = AppDesign.colors.primary;
                                break;
                              case Homework:
                                Homework hm = event as Homework;
                                color =  hm.subject.color;
                                break;
                              case Test:
                                Test test = event as Test;
                                return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color: test.subject.color
                                        )
                                    ),
                                    width: 9.0,
                                    height: 9.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5)
                                );
                            }
                            return Container(
                                decoration: BoxDecoration(shape: shape, color: color),
                                width: 7.0,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(horizontal: 1.5)
                            );
                          },
                        ),
                        formatAnimationCurve: Curves.easeOutBack,
                        formatAnimationDuration: const Duration(milliseconds: 500),
                        onFormatChanged: (format) {
                          setState(() {
                            BrainApp.updatePreference("calendarFormat", format.index);
                          });
                        },
                        onDaySelected: (_selectedDay, _focusedDay) {
                          setState(() {
                            CalendarPage.selectedDay = _selectedDay;
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(CalendarPage.selectedDay, day);
                        },
                        eventLoader: (date) {
                          List<dynamic> events = [
                            ...TimeTable.getEvents(date),
                            ...getHomeworkByDay(date),
                            ...TimeTable.getTests(date)
                          ];
                          return events;
                        }
                    )
                ),
                if (TimeTable.getTests(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Tests",
                  children: getSelectedTests(),
                ),
                if (getHomeworkByDay(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Hausaufgaben",
                  children: getSelectedHomework(),
                ),
                if (TimeTable.getEvents(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Termine",
                  children: getSelectedEvents(),
                )
              ]
          )
      )
    );
  }
}
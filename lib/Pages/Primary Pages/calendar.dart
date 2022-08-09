import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_dismissible.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}): super(key: key);

  static DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  _CalendarPage createState() => _CalendarPage();
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
              color: AppDesign.current.primaryColor,
              primaryText: events[i].name,
              child: events[i].description.isEmpty ? null : Text(events[i].description, style: AppDesign.current.textStyles.pointElementSecondary),
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
              style: AppDesign.current.textStyles.pointElementSecondary),
          )
        )
      );
    }

    return boxes;
  }

  List<Widget> getSelectedHomework() {
    List<Widget> boxes = [];
    List<Subject> subjects = [];
    for (Subject subject in TimeTable.getSubjectsByDate(CalendarPage.selectedDay)) {
      if(!subjects.contains(subject))subjects.add(subject);
    }

    for (Subject subject in subjects) {
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
    List<Subject> subjects = [];

    for (Subject subject in TimeTable.getSubjectsByDate(day)) {
      if(!subjects.contains(subject))subjects.add(subject);

    }
    for (Subject subject in subjects) {
      homework.addAll(TimeTable.getHomework(day, subject));
    }

    return homework;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.primaryVelocity! > 0.0) {
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
                        calendarFormat: widget.calendarFormat,
                        locale: "de_DE",
                        firstDay: DateTime.utc(2018, 10, 16),
                        lastDay: DateTime.now().add(const Duration(days:730)),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        focusedDay: CalendarPage.selectedDay,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
                          weekendTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
                          outsideTextStyle: TextStyle(color: AppDesign.current.textStyles.color.withOpacity(0.5)),
                          todayDecoration: BoxDecoration(color: AppDesign.current.themeData.scaffoldBackgroundColor, shape: BoxShape.circle),
                          todayTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
                          selectedDecoration: BoxDecoration(color: AppDesign.current.primaryColor, shape: BoxShape.circle),
                          selectedTextStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: AppDesign.current.textStyles.color),
                            weekendStyle: TextStyle(color: AppDesign.current.textStyles.color)
                        ),
                        headerStyle: HeaderStyle(
                          headerPadding: const EdgeInsets.only(bottom: 10),
                          titleTextStyle: TextStyle(color: AppDesign.current.textStyles.color, fontSize: 18, fontWeight: FontWeight.w600),
                          titleCentered: true,
                          formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppDesign.current.textStyles.color)
                          ),
                          leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.current.textStyles.color),
                          rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.current.textStyles.color),
                        ),
                        calendarBuilders: CalendarBuilders(
                          singleMarkerBuilder: (context, date, event) {
                            Color color = Colors.deepOrange;
                            BoxShape shape = BoxShape.circle;
                            switch (event.runtimeType) {
                              case Event:
                                shape = BoxShape.rectangle;
                                color = AppDesign.current.primaryColor;
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
                          setState(() => widget.calendarFormat = format);
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
                  headline: "Events",
                  children: getSelectedEvents(),
                )
              ]
          )
      )
    );
  }
}
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/dismissable_box.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/event_page.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}): super(key: key);

  @override
  _CalendarPage createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();

  List<Padding> getSelectedEvents() {
    List<Padding> boxes = [];
    List<Event> events = TimeTable.getEvents(selectedDay);
    for (int i=0; i<events.length; i++) {
      String? headline;
      if (i == 0) headline = "Events";

      boxes.add(
        Padding(
          padding: headline != null ? const EdgeInsets.only(bottom: 10, top: 30) : const EdgeInsets.only(bottom: 10),
          child: Box(
            headline: headline,
            child: PointElement(
              color: Colors.deepOrange,
              primaryText: events[i].name,
              child: Text(events[i].description, style: AppDesign.current.textStyles.pointElementSecondary),
            ),
          ),
        )
      );
    }

    return boxes;
  }

  List<Padding> getSelectedHomework() {
    List<Padding> boxes = [];
    List<Subject> subjects = [];
    String? headline;
    for (Subject subject in TimeTable.getSubjectsByDate(selectedDay)) {
      if(!subjects.contains(subject))subjects.add(subject);

    }
    for (Subject subject in subjects) {
      List<Homework> homework = TimeTable.getHomework(selectedDay, subject);
      List<DismissableBox> dismissableBoxes = [];

      for (Homework _homework in homework) {
        dismissableBoxes.add(
          DismissableBox(homework: _homework)
        );
      }

      if (dismissableBoxes.isNotEmpty) {
        if (boxes.isEmpty) headline = "Hausaufgaben";

        boxes.add(
          Padding(
            padding: headline != null ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 10),
            child: Box(
              headline: headline,
              child: PointElement(
                  color: subject.color,
                  primaryText: subject.name,
                  child: Column(
                    children: dismissableBoxes,
                  )
              ),
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
    return PageTemplate(
      title: "Kalender",
      subtitle: "Work in Progress",
      floatingActionButton: CustomMenuButton(
          icon: const Icon(Icons.add),
          defaultAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventPage())
          ),
          menuEntries: [
            CustomMenuButton.getHomeworkMenu(context),
            CustomMenuButton.getEventMenu(context)
          ]
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Box(
            child: TableCalendar(
                firstDay: DateTime.utc(2018, 10, 16),
                lastDay: DateTime.utc(2026, 3, 14),
                startingDayOfWeek: StartingDayOfWeek.monday,
                focusedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
                  weekendTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
                  outsideTextStyle: TextStyle(color: AppDesign.current.textStyles.color.withOpacity(0.5)),
                  todayDecoration: BoxDecoration(color: AppDesign.current.primaryColor.withAlpha(0), shape: BoxShape.circle),
                  todayTextStyle: TextStyle(color: AppDesign.current.primaryColor),
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
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.current.textStyles.color),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.current.textStyles.color),
                ),
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    Color color = Colors.deepOrange;
                    print(event.toString());
                    switch (event.toString()) {
                      case "Instance of 'Event'":
                        color = Colors.deepOrange;
                        break;
                      case "Instance of 'Homework'":
                        color = Colors.deepPurple;
                        break;
                    }
                    return Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  },
                ),
                onDaySelected: (_selectedDay, _focusedDay) {
                  setState(() {
                    selectedDay = _selectedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },
                eventLoader: (date) {
                  List<dynamic> events = [
                    ...TimeTable.getEvents(date),
                    ...getHomeworkByDay(date)
                  ];
                  return events;
                }
            )
          ),
          ...getSelectedEvents(),
          ...getSelectedHomework()
        ]
      )
    );
  }
}
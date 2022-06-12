import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/custom_inputs.dart';
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
      EdgeInsets padding = const EdgeInsets.only(bottom: 10);
      if (i == 0) headline = "Events";

      boxes.add(
        Padding(
          padding: padding,
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
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
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
                  titleTextStyle: TextStyle(color: AppDesign.current.textStyles.color, fontSize: 18, fontWeight: FontWeight.w600),
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.current.textStyles.color),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.current.textStyles.color),
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
                  return TimeTable.getEvents(date);
                }
            ),
          ),
          ...getSelectedEvents()
        ]
      )
    );
  }
}
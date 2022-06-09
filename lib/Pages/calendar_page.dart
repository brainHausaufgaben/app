import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}): super(key: key);

  @override
  _CalendarPage createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Kalender",
      subtitle: "Work in Progress",
      child: TableCalendar(
        firstDay: DateTime.utc(2018, 10, 16),
        lastDay: DateTime.utc(2026, 3, 14),
        startingDayOfWeek: StartingDayOfWeek.monday,
        focusedDay: DateTime.now(),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
          weekendTextStyle: TextStyle(color: AppDesign.current.textStyles.color),
          outsideTextStyle: TextStyle(color: AppDesign.current.textStyles.color.withOpacity(0.5)),
          todayDecoration: BoxDecoration(color: AppDesign.current.primaryColor, shape: BoxShape.circle)
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: AppDesign.current.textStyles.color, fontSize: 18, fontWeight: FontWeight.w600),
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.current.textStyles.color),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.current.textStyles.color)
        ),
      ),
    );
  }
}
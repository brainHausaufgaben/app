import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}): super(key: key);

  @override
  _CalendarPage createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Kalender",
      child: Text("Hallo Manuel was geht ab \n"
          "ich hab das ding gemacht und du kannst mit getSubjectInstancesByDate() und getSubjectsByDate() bei timetable die fächer und die instances bekommen "
          "aber das mit instances ist eig relativ unnötig also ja keine ahnung  wenn man will kann man aber muss nicht neh"),
    );
  }
}
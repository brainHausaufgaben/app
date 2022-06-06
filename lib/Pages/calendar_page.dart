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
      child: Text("Hey"),
    );
  }
}
import 'package:brain_app/Pages/calendar_page.dart';
import 'package:brain_app/Pages/events_page.dart';
import 'package:brain_app/Pages/grade_overview_page.dart';
import 'package:brain_app/Pages/grades_page.dart';
import 'package:brain_app/Pages/home_page.dart';
import 'package:brain_app/Pages/homework_page.dart';
import 'package:brain_app/Pages/settings_page.dart';
import 'package:brain_app/Pages/subject_overview.dart';
import 'package:brain_app/Pages/subject_page.dart';
import 'package:brain_app/Pages/time_table_page.dart';
import 'package:flutter/material.dart';

class NavigatorRoutes {
  static Map<String, Widget Function(BuildContext)> get() {
    return {
      "/home": (context) => HomePage(),
      "/calendar": (context) => CalendarPage(),
      "/settings": (context) => SettingsPage(),
      "/settings/timetable": (context) => TimeTablePage(),
      "/settings/timetable/subjectOverview" : (context) => SubjectOverview(),
      "/settings/timetable/subjectPage" : (context) => SubjectPage(),
      "/homeworkPage" : (context) => HomeworkPage(),
      "/eventsPage" : (context) => EventsPage(),
      "/gradesPage" : (context) => GradesPage(),
      "/gradeOverview" : (context) => GradeOverview()
    };
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:brain_app/Pages/Primary%20Pages/grades.dart';
import 'package:brain_app/Pages/Primary%20Pages/home.dart';
import 'package:brain_app/Pages/add_edit_grades.dart';
import 'package:brain_app/Pages/add_edit_homework.dart';
import 'package:brain_app/Pages/add_edit_subjects.dart';
import 'package:brain_app/Pages/add_events.dart';
import 'package:brain_app/Pages/design_settings.dart';
import 'package:brain_app/Pages/edit_events.dart';
import 'package:brain_app/Pages/edit_tests.dart';
import 'package:brain_app/Pages/grades_per_subject.dart';
import 'package:brain_app/Pages/settings.dart';
import 'package:brain_app/Pages/subject_overview.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Components/brain_navigation_bar.dart';

import '../Backend/quick_actions.dart';


class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> rootKey = GlobalKey();
  static ValueNotifier<int> selectedPrimaryPage = ValueNotifier<int>(1);

  static NavigatorState getNavigator(BuildContext context, {bool forceNested = false}) {
    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth || forceNested) {
      return navigatorKey.currentState!;
    } else {
      return rootKey.currentState!;
    }
  }

  static void pushNamed(BuildContext context, String route, {dynamic payload}) async {
    getNavigator(context).pushNamed(route, arguments: payload);
  }

  static void pushNamedReplacement(BuildContext context, String route) {
    getNavigator(context, forceNested: true).pushReplacementNamed(route);
  }

  @override
  _NavigationHelper createState() => _NavigationHelper();
}

class _NavigationHelper extends State<NavigationHelper> {
  Widget wrapInSidebar(Widget child) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: child,
                  ),
                )
              ]
          )
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget navigator = Navigator(
      key: NavigationHelper.navigatorKey,
      initialRoute: "home",
      onGenerateRoute: NavigationRoutes.onGenerateRoute
    );

    return WillPopScope(
      onWillPop: () async {
        return !await NavigationHelper.navigatorKey.currentState!.maybePop();
      },
      child: Scaffold(
        body: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
            ? wrapInSidebar(navigator)
            : navigator,
        bottomNavigationBar: MediaQuery.of(context).size.width < AppDesign.breakPointWidth
            ? CustomNavigationBar()
            : null,
      ),
    );
  }
}

class NavigationRoutes {
  static Map<String, WidgetBuilder> get() {
    return {
      "/": (context) => kIsWeb
          ? NavigationHelper()
          : CustomQuickActions(child: NavigationHelper()),
      "home": (context) => HomePage(),
      "calendar": (context) => CalendarPage(),
      "editEventsPage": (context) => EditEventPage(),
      "addEventPage": (context) => AddEventsPage(),
      "editTestPage": (context) => EditTestPage(),
      "gradesOverview": (context) => GradeOverview(),
      "gradesPerSubject": (context) => GradesPerSubjectPage(),
      "gradesPage": (context) => GradesPage(),
      "subjectOverview": (context) => SubjectOverview(),
      "subjectPage": (context) => SubjectPage(),
      "timeTable": (context) => TimeTablePage(),
      "settings": (context) => SettingsPage(),
      "homework": (context) => HomeworkPage(),
      "designSettings": (context) => DesignSettingsPage()
    };
  }

  static PageRouteBuilder onGenerateRoute(settings) {
    Map<String, WidgetBuilder> routes = NavigationRoutes.get();

    return PageRouteBuilder(
        pageBuilder: (context, a1, a2) => routes[settings.name!]!(context),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const offsetBegin = Offset(0, 0.15);
          const offsetEnd = Offset(0, 0);
          const begin = 0.0;
          const end = 1.0;
          final tween = Tween(begin: begin, end: end);
          final offsetTween = Tween(begin: offsetBegin, end: offsetEnd);

          return FadeTransition(
            opacity: tween.animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutBack
            )),
            child: SlideTransition(
              position: offsetTween.animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutBack
              )),
              child: child,
            ),
          );
        },
        settings: settings
    );
  }
}
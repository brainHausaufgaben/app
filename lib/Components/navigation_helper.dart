import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:brain_app/Pages/calendar_page.dart';
import 'package:brain_app/Pages/home_page.dart';
import 'package:brain_app/Pages/settings_page.dart';
import 'package:brain_app/Pages/subject_overview.dart';
import 'package:brain_app/Pages/subject_page.dart';
import 'package:brain_app/Pages/time_table_page.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/Components/custom_navigation_bar.dart';

class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static BuildContext get context => navigatorKey.currentContext!;

  @override
  _NavigationHelper createState() => _NavigationHelper();
}

class _NavigationHelper extends State<NavigationHelper> {

  Widget wrapInSidebar(Widget child) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSidebar(),
                Expanded(
                  child: child,
                )
              ]
          )
      )
    );
  }

  Widget test(BuildContext context) {
    return const Text("hey");
  }

  Map<String, WidgetBuilder> routeBuilders(BuildContext context) {
    return {
      "/": (context) => HomePage(),
      "/calendar": (context) => CalendarPage(),
      "/settings": (context) => SettingsPage(),
      "/settings/timetable": (context) => TimeTablePage(),
      "/settings/timetable/subjectOverview" : (context) => SubjectOverview(),
      "/settings/timetable/edit" : (context) => SubjectPage()
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = routeBuilders(context);

    Widget navigator = Navigator(
        key: NavigationHelper.navigatorKey,
        initialRoute: "/",
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routes[routeSettings.name]!(context),
          );
        }
    );

    return Scaffold(
      body: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
          ? wrapInSidebar(navigator)
          : navigator,
      bottomNavigationBar: MediaQuery.of(context).size.width > AppDesign.breakPointWidth ? null : CustomNavigationBar(),
    );
  }
}
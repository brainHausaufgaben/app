import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:brain_app/Pages/Primary%20Pages/grades.dart';
import 'package:brain_app/Pages/Primary%20Pages/home.dart';
import 'package:brain_app/Pages/add_edit_grades.dart';
import 'package:brain_app/Pages/add_edit_subjects.dart';
import 'package:brain_app/Pages/design_settings.dart';
import 'package:brain_app/Pages/settings.dart';
import 'package:brain_app/Pages/subject_overview.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Components/custom_navigation_bar.dart';

import '../Backend/quick_actions.dart';


class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> rootKey = GlobalKey();

  static BuildContext get context => navigatorKey.currentContext!;

  static NavigatorState getNavigator([bool forceNested = false]) {
    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth || forceNested) {
      return Navigator.of(context);
    } else {
      return Navigator.of(context, rootNavigator: true);
    }
  }

  static void pop() {
    getNavigator().pop();
  }

  static void push(Widget route) {

  }

  static void pushNamed(String route, {dynamic payload}) {
    getNavigator().pushNamed(route, arguments: payload);
  }

  static void replaceCurrent(Widget route, [forceNested = false]) {
    // getNavigator(forceNested).pushReplacement(getRouteBuilder(route));
  }

  static FadeTransition transitionBuilder(context, animation, secondaryAnimation, child) {
    const begin = 0.0;
    const end = 1.0;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(tween);

    return FadeTransition(
      opacity: offsetAnimation,
      child: child,
    );
  }

  static PageRoute getRouteBuilder(String route) {
    Map<String, WidgetBuilder> routes = NavigationRoutes.get();

    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
      return PageRouteBuilder(
        pageBuilder: (context, a1, a2) => routes[route]!(context),
        transitionsBuilder: transitionBuilder,
      );
    } else {
      return MaterialPageRoute(
          builder: routes[route]!
      );
    }
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
      onGenerateRoute: (settings) {
          return NavigationHelper.getRouteBuilder(settings.name!);
      },

    );

    return WillPopScope(
      onWillPop: () async {
        NavigationHelper.pop();
        return false;
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
      "gradesOverview": (context) => GradeOverview(),
      "gradesPage": (context) => GradesPage(),
      "subjectOverview": (context) => SubjectOverview(),
      "subjectPage": (context) => SubjectPage(),
      "timeTable": (context) => TimeTablePage(),
      "settings": (context) => SettingsPage(),
      "designSettings": (context) => DesignSettingsPage()
    };
  }
}
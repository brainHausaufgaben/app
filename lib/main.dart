import 'dart:ui';

import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/initializer.dart';
import 'package:brain_app/Backend/notifier.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BrainApp());
}

class BrainApp extends StatefulWidget {
  const BrainApp({Key? key}) : super(key: key);

  static Notifier notifier = Notifier();

  static String appVersion = "...";
  static TodaysMedia? todaysMedia;
  static double screenWidth = 0;

  static Map<String, dynamic> preferences = {
    "showMediaBox": true,
    "persistentNotifications": false,
    "homeworkNotifications": false,
    "notificationTime": "16:00",
    "testNotifications": false,
    "daysUntilNotification": 1,
    "design": "Monochrome",
    "darkMode": MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness == Brightness.dark,
    "pinnedHeader": true,
    "calendarFormat" : 0,
    "overridePrimaryWith" : MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness == Brightness.dark ? Colors.white.value : Colors.black.value,
    "showDeveloperOptions" : false,
    "currentSemester" : 0,
    "showLogsOnScreen" : false,
    "saveLogs" : false,
    "isAdvancedLevel" : false,
    "currentYear" : 10,
    "manuelClickerScore" : 0,
    "showPlayStorePopup" : true
  };

  static void clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void updatePreference(String key, dynamic value) async {
    preferences[key] = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case String:
        prefs.setString(key, value);
        break;
      case bool:
        prefs.setBool(key, value);
        break;
      case int:
        prefs.setInt(key, value);
        break;
    }
  }

  @override
  State<BrainApp> createState() => _BrainApp();
}

class _BrainApp extends State<BrainApp> {
  @override
  void initState() {
    BrainApp.notifier.addListener(() => setState(() {}));
    Initializer.init().then((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppDesign.colors.background,
      navigatorKey: NavigationHelper.rootKey,
      title: 'Brain Hausaufgaben',
      initialRoute: "/",
      onGenerateRoute: NavigationRoutes.onGenerateRoute,
      theme: AppDesign.themeData,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('de', 'DE')
      ],
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: StretchingIndicator(),
          child: child!,
        );
      },
    );
  }
}

class StretchingIndicator extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown
  };

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
        axisDirection: details.direction,
        child: child
    );
  }
}

class TodaysMedia {
  TodaysMedia({
    required this.icon,
    required this.content,
    required this.type
  });

  final IconData icon;
  final String content;
  final String type;
}
import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io'show Platform;

import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotifications{
  static final AndroidFlutterLocalNotificationsPlugin notificationsPlugin = AndroidFlutterLocalNotificationsPlugin();
  static DateTime notificationTime = DateTime(0,0,0,16,00);
  static int daysBeforeTest = 1;
  static int currentHomeworkNotificationID = 0;
  static int currentTestNotificationID = 1000;
  static bool permaNotificationEnabled = true;
  static bool homeworkNotificationsEnabled = true;
  static bool testNotificationsEnabled = true;
  static bool notificationsPossible = true;


  static Future init() async{
//bwuh
    if(kIsWeb){
      notificationsPossible = false;
      return;
    }
    if(!Platform.isAndroid){
      notificationsPossible = false;
      return;
    }

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/launcher_monochrome');
    await notificationsPlugin.initialize(initializationSettingsAndroid,onSelectNotification:selectNotification );

    SharedPreferences.getInstance().then((preferences) {
      if(preferences.getBool("persistentNotifications") ?? false){
        CustomNotifications.enablePermaNotification();
      }
      else{
        CustomNotifications.disablePermaNotification();
      }
      homeworkNotificationsEnabled = preferences.getBool("homeworkNotifications") ?? true;

    });

    if(BrainApp.preferences["persistentNotifications"]){
      enablePermaNotification();
    }
    else{
      disablePermaNotification();
    }
    homeworkNotificationsEnabled = BrainApp.preferences["homeworkNotifications"];
    testNotificationsEnabled = BrainApp.preferences["testNotifications"];
    String savedTime = BrainApp.preferences["notificationTime"];
    List<String> split = savedTime.split(RegExp(":"));
    notificationTime = DateTime(0,0,0, int.parse(split[0]),int.parse(split[1]) );
    daysBeforeTest = BrainApp.preferences["daysUntilNotification"];

  }

  static void enablePermaNotification() async {
    permaNotificationEnabled = true;
    persistentNotification();
  }

  static void disablePermaNotification() async {
    permaNotificationEnabled = false;
    notificationsPlugin.cancel(0);

  }

  static Future selectNotification(String? payload) async {
    //nichts ;)
  }

  static void homeworkNotification(Homework homework) async{
    if(!homeworkNotificationsEnabled || !notificationsPossible) return;
    const StyleInformation defStyleInformation = DefaultStyleInformation(true, true);
    String title = "<b> Hausaufgabe bis Morgen</b>";
    String body = homework.subject.name + ": " +homework.name;
    currentHomeworkNotificationID++;
    const AndroidNotificationDetails platformChannelSpecifics =
    AndroidNotificationDetails(
      "1",
      "Hausaufgaben Benachrichtigung",
      channelDescription: 'Hausaufgaben Benachrichtigung',
      styleInformation: defStyleInformation,
    );
    initializeTimeZones();
    DateTime scheduleTime = homework.dueTime.subtract(const Duration(days: 1));
    TZDateTime scheduleZonedTime = TZDateTime(getLocation("Europe/Zurich"),scheduleTime.year,scheduleTime.month,scheduleTime.day,notificationTime.hour,notificationTime.minute);
    BrainDebug.log("Homework notification" + scheduleZonedTime.toString());
    homework.notificationID = currentHomeworkNotificationID;
    if(!scheduleZonedTime.isBefore(TZDateTime.now(getLocation("Europe/Zurich")))) {
      await notificationsPlugin.zonedSchedule(currentHomeworkNotificationID, title, body, scheduleZonedTime, platformChannelSpecifics, androidAllowWhileIdle: true);
    } else {
      await notificationsPlugin.show(currentHomeworkNotificationID, title, body,notificationDetails: platformChannelSpecifics);
      BrainDebug.log("added too late, showing now");
    }
  }

  static void testNotification(Test test) async{
    if(!testNotificationsEnabled || !notificationsPossible) return;
    const StyleInformation defStyleInformation = DefaultStyleInformation(true, true);
    String title = "Test in " + test.subject.name + " in " + daysBeforeTest.toString() + " Tagen";
    String body = test.description;
    currentTestNotificationID++;
    const AndroidNotificationDetails platformChannelSpecifics =
    AndroidNotificationDetails("2","Test Benachrichtigung",channelDescription: 'Test Benachrichtigung',styleInformation: defStyleInformation);
    initializeTimeZones();
    DateTime scheduleTime = test.dueTime.subtract(Duration(days: daysBeforeTest));

    TZDateTime scheduleZonedTime = TZDateTime(getLocation("Europe/Zurich"),scheduleTime.year,scheduleTime.month,scheduleTime.day,notificationTime.hour,notificationTime.minute);
    test.notificationID = currentTestNotificationID;
    BrainDebug.log("Test notification" + scheduleZonedTime.toString());
    if(!scheduleZonedTime.isBefore(TZDateTime.now(getLocation("Europe/Zurich")))) {
      await notificationsPlugin.zonedSchedule(currentTestNotificationID, title, body, scheduleZonedTime, platformChannelSpecifics, androidAllowWhileIdle: true);
    } else {
      await notificationsPlugin.show(currentTestNotificationID, title, body,notificationDetails: platformChannelSpecifics);
      BrainDebug.log("added to late, showing now");
    }
  }

  static void persistentNotification() async {
    if(!permaNotificationEnabled || !notificationsPossible) return;
    const StyleInformation defStyleInformation = DefaultStyleInformation(true, true);
    String title = "";
    String body = "";
    if(TimeTable.homeworks.isNotEmpty){
      title = "<b> Achtung! </b>";
      body = "Du hast noch " + TimeTable.homeworks.length.toString() + " unerledigte Hausaufgabe";
      if (TimeTable.homeworks.length > 1) body += "n";
    }
    else{
      title = "<b> Gut gemacht! </b>";
      body =  "Du hast schon alle Hausaufgaben erledigt";
    }

    const AndroidNotificationDetails platformChannelSpecifics =
    AndroidNotificationDetails('0', "Dauer Benachrichtigung",
        showWhen: false,
        channelDescription: 'your channel description',
        ongoing: true,
        autoCancel: false,
        enableVibration: false,
        enableLights: false,
        playSound: false,
        styleInformation: defStyleInformation,
        ticker: 'ticker');
    await notificationsPlugin.show(
        0, title , body,notificationDetails: platformChannelSpecifics,payload: "perm");
  }




}
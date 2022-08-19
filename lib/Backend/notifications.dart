import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io'show Platform;

import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotifications{
  static final AndroidFlutterLocalNotificationsPlugin notificationsPlugin = AndroidFlutterLocalNotificationsPlugin();
  static DateTime notificationTime = DateTime(0,0,0,16,00);
  static int currentHomeworkNotificationID = 0;
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

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launcher_icon');
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
    AndroidNotificationDetails("1","Hausaufgaben Benachrichtigung",channelDescription: 'Hausaufgaben Benachrichtigung',styleInformation: defStyleInformation);
    initializeTimeZones();
    DateTime scheduleTime = homework.dueTime.subtract(const Duration(days: 1));
    TZDateTime scheduleZonedTime = TZDateTime(getLocation("Europe/Zurich"),scheduleTime.year,scheduleTime.month,scheduleTime.day,notificationTime.hour,notificationTime.minute);
    homework.notificationID = currentHomeworkNotificationID;
    if(!scheduleZonedTime.isBefore(TZDateTime.now(getLocation("Europe/Zurich")))) {
      await notificationsPlugin.zonedSchedule(currentHomeworkNotificationID, title, body, scheduleZonedTime, platformChannelSpecifics, androidAllowWhileIdle: true);
    } else {
      await notificationsPlugin.show(currentHomeworkNotificationID, title, body,notificationDetails: platformChannelSpecifics);
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
      title = "<b> Gut Gemacht! </b>";
      body =  "Du hast schon alle Hausaufgaben erledigt";
    }

    const AndroidNotificationDetails platformChannelSpecifics =
    AndroidNotificationDetails('0', "Dauer Benachtichtigung",
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
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'dart:io'show Platform;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotifications{
  static final AndroidFlutterLocalNotificationsPlugin notificationsPlugin = AndroidFlutterLocalNotificationsPlugin();
  static bool notificationsEnabled = true;
  static bool notificationsPossible = true;

  static void init() async{

    if(kIsWeb){
      notificationsPossible = false;
      return;
    }
    if(!Platform.isAndroid){
      notificationsPossible = false;
      return;
    }

    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    await notificationsPlugin.initialize(initializationSettingsAndroid);

    SharedPreferences.getInstance().then((preferences) {
      if(preferences.getBool("persistentNotifications") ?? false){
        CustomNotifications.enableNotifications();
      }
      else{
        CustomNotifications.disableNotifications();
      }
    });
  }

  static void enableNotifications() async {
    notificationsEnabled = true;
    persistentNotification();
  }

  static void disableNotifications() async {
    notificationsEnabled = false;
    notificationsPlugin.cancel(0);

  }

  static void persistentNotification() async{
    if(!notificationsEnabled || !notificationsPossible) return;

    const StyleInformation defStyleInformation = DefaultStyleInformation(true, true);
    String title = "";
    String body = "";
    if(TimeTable.homeworks.isNotEmpty){
      title = "<b> Achtung! </b>";
      body = "Du hast noch " + TimeTable.homeworks.length.toString() + " unerledigte Hausaufgaben";
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
        enableVibration: false,
        enableLights: false,
        playSound: false,
        styleInformation: defStyleInformation,
        ticker: 'ticker');
    await notificationsPlugin.show(
        0, title , body,notificationDetails: platformChannelSpecifics,);


  }

}
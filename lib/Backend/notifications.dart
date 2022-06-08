import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotifications{
  static final AndroidFlutterLocalNotificationsPlugin notificationsPlugin = AndroidFlutterLocalNotificationsPlugin();

  static void init() async{
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    await notificationsPlugin.initialize(initializationSettingsAndroid);
  }

  static void presistentNotification() async{
    const StyleInformation defStyleInformation = DefaultStyleInformation(true, true);
    const StyleInformation styleInformation = BigTextStyleInformation("<b> bigText </b>",htmlFormatBigText: true,htmlFormatContentTitle: true);
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
    AndroidNotificationDetails('0', 'your channel name',
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
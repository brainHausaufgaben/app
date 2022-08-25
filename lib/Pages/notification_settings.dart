import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

import '../Backend/notifications.dart';
import '../main.dart';

class NotificationSettings extends StatefulWidget {
  NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettings();
}

class _NotificationSettings extends State<NotificationSettings> {
  TimeOfDay parseTime(String timeAsString) {
    List<String> splitString = timeAsString.split(":");
    return TimeOfDay(hour: int.parse(splitString[0]), minute: int.parse(splitString[1]));
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: "Benachrichtigungen",
        subtitle: "Version " + BrainApp.appVersion,
        backButton: true,
        child: Wrap(
            runSpacing: 10,
            children: [
              SettingsEntry(
                  children: [
                    SettingsSwitchButton(
                      text: "Anhaltende Benachrichtigung",
                      action: () {
                        setState(() {
                          BrainApp.updatePreference("persistentNotifications", !BrainApp.preferences["persistentNotifications"]);

                          if(BrainApp.preferences["persistentNotifications"]){
                            CustomNotifications.enablePermaNotification();
                          } else{
                            CustomNotifications.disablePermaNotification();
                          }
                        });
                      },
                      state: BrainApp.preferences["persistentNotifications"],
                    ),
                  ]
              ),
              SettingsEntry(
                children: [
                  SettingsSwitchButton(
                      text: "Hausaufgaben Benachrichtigungen",
                      action: () {
                        setState(() {
                          BrainApp.updatePreference("homeworkNotifications", !BrainApp.preferences["homeworkNotifications"]);
                          CustomNotifications.homeworkNotificationsEnabled = BrainApp.preferences["homeworkNotifications"];
                        });
                      },
                      state: BrainApp.preferences["homeworkNotifications"]
                  ),
                  SettingsTimePicker(
                    text: "Immer am Vortag um...",
                    currentTime: parseTime(BrainApp.preferences["notificationTime"]),
                    onSelect: (time) {
                      setState(() {
                        CustomNotifications.notificationTime = DateTime(0);
                        BrainApp.updatePreference("notificationTime", "${time.hour}:${time.minute}");
                      });
                    },
                  )
                ],
              ),
              SettingsEntry(
                children: [
                  SettingsSwitchButton(
                      text: "Schulaufgaben Benachrichtigungen",
                      action: () {
                        setState(() {
                          BrainApp.updatePreference("testNotifications", !BrainApp.preferences["testNotifications"]);
                          CustomNotifications.homeworkNotificationsEnabled = BrainApp.preferences["testNotifications"];
                        });
                      },
                      state: BrainApp.preferences["testNotifications"]
                  ),
                  SettingsNumberPicker(
                    text: "Immer ... Tage vorher",
                    currentValue: BrainApp.preferences["daysUntilNotification"],
                    action: (value) {
                      setState(() {
                        BrainApp.updatePreference("daysUntilNotification", value);
                        CustomNotifications.daysBeforeTest = value;
                      });
                    }
                  )
                ]
              )
            ]
        )
    );
  }
}
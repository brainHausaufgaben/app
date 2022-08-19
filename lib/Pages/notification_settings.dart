import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

import '../Backend/notifications.dart';
import '../main.dart';

class NotificationSettings extends StatefulWidget {
  NotificationSettings({Key? key}) : super(key: key);

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  State<NotificationSettings> createState() => _NotificationSettings();
}

class _NotificationSettings extends State<NotificationSettings> {
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
                            CustomNotifications.enableNotifications();
                          } else{
                            CustomNotifications.disableNotifications();
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
                      text: "Hausaufgaben Benachrichtigung",
                      action: () {
                        setState(() {
                          BrainApp.updatePreference("homeworkNotifications", !BrainApp.preferences["homeworkNotifications"]);
                        });
                      },
                      state: BrainApp.preferences["homeworkNotifications"]
                  ),
                  SettingsTimePicker(
                    text: "Immer am Vortag um...",
                    currentTime: widget.selectedTime,
                    onSelect: (time) {
                      setState(() => widget.selectedTime = time);
                    },
                  )
                ],
              )
            ]
        )
    );
  }
}
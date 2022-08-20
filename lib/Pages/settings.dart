import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Einstellungen",
      subtitle: "Version " + BrainApp.appVersion,
      backButton: true,
      pageSettings: const PageSettings(
        developerOptions: true
      ),
      child: Wrap(
        runSpacing: 10,
        children: [
          SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Stundenplan",
                action: () => NavigationHelper.pushNamed(context, "timeTable")
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Design & Ansicht",
                action: () => NavigationHelper.pushNamed(context, "designSettings")
              ),
              SettingsNavigatorButton(
                  text: "Benachrichtigungen",
                  description: kIsWeb ? "In der Webversion nicht verfügbar" : null,
                  activated: !kIsWeb,
                  action: () => NavigationHelper.pushNamed(context, "notificationSettings")
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsLinkButton(
                text: "Mebis",
                link: "https://lernplattform.mebis.bayern.de/my/",
              ),
              SettingsLinkButton(
                text: "Bug melden",
                link: "https://forms.gle/GcfGNa1Lhvnt245Y6",
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Über die App",
                action: () => showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                    applicationName: "Brain App",
                    applicationVersion: BrainApp.appVersion,
                    applicationIcon: Image.asset("icons/appIcon.jpg", width: 60, height: 60),
                    children: const [
                      Text("Entwickler: Sebastian Merk, Manuel Murmann"),
                      Text("Designer: Manuel Murmann"),
                      Text("Project Manager: David Will (aber nicht wirklich)")
                    ],
                  )
                ),
              )
            ],
          )
        ]
      )
    );
  }
}
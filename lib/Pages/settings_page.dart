import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Pages/time_table_page.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final List<bool> radioList = List.filled(Design.allDesigns.length, false);
  String version = "...";

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  List<IconRadio> getRadios() {
    List<IconRadio> radios = [];
    int index = 0;

    Design.allDesigns.forEach((key, value) {
      radios.add(IconRadio(isSelected: radioList[index], path: value.iconPath, tooltip: key));
      index++;
    });

    return radios;
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      BrainApp.notifier.notifyOfChanges();
    });
  }

  Widget getThemeChooser() {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
                onPressed: (index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < radioList.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        AppDesign.toggleTheme(Design.allDesigns.keys.elementAt(buttonIndex));
                        radioList[buttonIndex] = true;
                      } else {
                        radioList[buttonIndex] = false;
                      }
                    }
                  });
                },
                splashColor: Colors.transparent,
                fillColor: Colors.transparent,
                renderBorder: false,
                isSelected: radioList,
                children: getRadios()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Einstellungen",
      subtitle: "Version " + version,
      backButton: true,
      child: Wrap(
        runSpacing: 10,
        children: [
          SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Stundenplan",
                action: () {
                  Navigator.of(context).pushNamed("/settings/timetable");
                },
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsSwitchButton(
                text: "Darkmode",
                action: () {
                  AppDesign.toggleDarkMode();
                },
                state: BrainApp.preferences["darkMode"],
              ),
              getThemeChooser()
            ]
          ),
          SettingsEntry(
            children: [
              SettingsSwitchButton(
                text: "Witze, Funfacts...",
                action: () {
                  setState(() {
                    BrainApp.updatePreference("showMediaBox", !BrainApp.preferences["showMediaBox"]);
                    BrainApp.notifier.notifyOfChanges();
                  });
                },
                state: BrainApp.preferences["showMediaBox"],
              ),
              SettingsSwitchButton(
                text: "Benachrichtigungen",
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
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsLinkButton(
                text: "Bug melden",
                link: "https://forms.gle/GcfGNa1Lhvnt245Y6",
              )
            ],
          ),
        ]
      )
    );
  }
}

class IconRadio extends StatelessWidget {
  IconRadio({
    Key? key,
    required this.isSelected,
    required this.path,
    required this.tooltip
  }) : super(key: key);

  bool isSelected;
  String tooltip;
  String path;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
            color: isSelected ? AppDesign.current.primaryColor.withAlpha(50) : null,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Image(image: AssetImage(path), width: 45, height: 55),
        ),
      ),
    );
  }
}
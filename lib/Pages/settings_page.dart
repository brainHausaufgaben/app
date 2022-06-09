import 'package:brain_app/Backend/preferences.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final List<bool> radioList = List.filled(Designs.themeList.length, false);
  String version = "laden...";

  @override
  void initState() {
    super.initState();
    radioList[Designs.themeList.indexOf(AppDesign.currentThemeName)] = true;
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
                        BrainApp.design.toggleTheme(Designs.themeList[buttonIndex]);
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
                children: [
                  IconRadio(isSelected: radioList[0], path: "icons/monochromeThemeIcon.png", tooltip: "Monochrome"),
                  IconRadio(isSelected: radioList[1], path: "icons/orangeThemeIcon.png", tooltip: "Carrot Orange"),
                  IconRadio(isSelected: radioList[2], path: "icons/poisonGreenThemeIcon.png", tooltip: "Poison Green"),
                  IconRadio(isSelected: radioList[3], path: "icons/militaryGreenThemeIcon.png", tooltip: "Military Green"),
                  IconRadio(isSelected: radioList[4], path: "icons/pastellRedThemeIcon.png", tooltip: "Pastel Red"),
                  IconRadio(isSelected: radioList[5], path: "icons/jeremiasThemeIcon.png", tooltip: "Jeremias"),
                  IconRadio(isSelected: radioList[6], path: "icons/helpThemeIcon.png", tooltip: "Ocean Blue")
                ]
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTablePage()));
                },
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsSwitchButton(
                text: "Darkmode",
                action: () {
                  BrainApp.design.toggleDarkMode();
                },
                state: AppDesign.darkMode,
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
                    Preferences.setBool("showMediaBox", !Preferences.getBool("showMediaBox"));
                    BrainApp.notifier.notifyOfChanges();
                  });
                },
                state: Preferences.getBool("showMediaBox"),
              ),
              SettingsSwitchButton(
                text: "Benachrichtigungen",
                action: () {
                  setState(() {
                    Preferences.setBool("persistentNotifications", !Preferences.getBool("persistentNotifications"));
                  });
                },
                state: Preferences.getBool("persistentNotifications"),
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
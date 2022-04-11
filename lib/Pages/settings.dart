import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final List<bool> radioList = List.filled(Designs.themeList.length, false);

  @override
  void initState() {
    super.initState();
    radioList[Designs.themeList.indexOf(AppDesign.currentThemeName)] = true;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Einstellungen",
      subtitle: "Version xx.xx",
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
                  currentDesign.toggleDarkMode();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ToggleButtons(
                    onPressed: (index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < radioList.length; buttonIndex++) {
                          if (buttonIndex == index) {
                            currentDesign.toggleTheme(Designs.themeList[buttonIndex]);
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
                      IconRadio(isSelected: radioList[0], path: "icons/monochromeThemeIcon.png"),
                      IconRadio(isSelected: radioList[1], path: "icons/orangeThemeIcon.png"),
                      IconRadio(isSelected: radioList[2], path: "icons/poisonGreenThemeIcon.png"),
                      IconRadio(isSelected: radioList[3], path: "icons/militaryGreenThemeIcon.png"),
                      IconRadio(isSelected: radioList[4], path: "icons/pastellRedThemeIcon.png"),
                      IconRadio(isSelected: radioList[5], path: "icons/helpThemeIcon.png")
                    ]
                  )
                )
              )
            ]
          )
        ]
      )
    );
  }
}

class IconRadio extends StatelessWidget {
  IconRadio({
    Key? key,
    required this.isSelected,
    required this.path
  }) : super(key: key);

  bool isSelected;
  String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: isSelected ? AppDesign.current.primaryColor.withAlpha(50) : null,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Image(image: AssetImage(path), width: 45, height: 55),
      ),
    );
  }
}
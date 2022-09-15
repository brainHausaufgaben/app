import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/theming_utilities.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Components/navigation_helper.dart';
import '../main.dart';

class DesignSettingsPage extends StatefulWidget {
  const DesignSettingsPage({Key? key}) : super(key: key);

  @override
  State<DesignSettingsPage> createState() => _DesignSettingsPage();
}

class _DesignSettingsPage extends State<DesignSettingsPage> {
  final List<bool> radioList = List.filled(Design.allDesigns.length, false);

  @override
  void initState() {
    super.initState();
    radioList[Design.allDesigns.keys.toList().indexOf(BrainApp.preferences["design"])] = true;
  }

  List<IconRadio> getRadios() {
    List<IconRadio> radios = [];
    int index = 0;

    Design.allDesigns.forEach((key, value) {
      radios.add(IconRadio(isSelected: radioList[index], design: value, tooltip: key));
      index++;
    });

    return radios;
  }

  Widget getThemeChooser() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
      child: NotificationListener<OverscrollNotification> (
        onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: "Design & Ansicht",
        subtitle: "Version " + BrainApp.appVersion,
        backButton: true,
        child: Wrap(
          runSpacing: 10,
          children: [
            SettingsEntry(
                children: [
                  SettingsSwitchButton(
                    text: "Darkmode",
                    action: () => AppDesign.toggleDarkMode(),
                    state: BrainApp.preferences["darkMode"],
                  ),
                  getThemeChooser(),

                ]
            ),
            if (BrainApp.preferences["design"] == "Monochrome") SettingsEntry(
              children: [
                SettingsColorPicker(
                    pickerColor: Color(BrainApp.preferences["overridePrimaryWith"]),
                    onColorSelect: (color) {
                      BrainApp.updatePreference("overridePrimaryWith", color.value);
                      AppDesign.setAccentColor();
                      Navigator.of(NavigationHelper.rootKey.currentContext!).pop();
                    }
                )
              ],
            ),
            SettingsEntry(
              children: [
                SettingsSwitchButton(
                  text: "Angepinnte Boxen",
                  description: "Beeinflusst ob angepinnte Container mit dem Rest des Inhalts scrollen",
                  action: () {
                    setState(() {
                      BrainApp.updatePreference("pinnedHeader", !BrainApp.preferences["pinnedHeader"]);
                      BrainApp.notifier.notifyOfChanges();
                    });
                  },
                  state: BrainApp.preferences["pinnedHeader"],
                ),
                SettingsSwitchButton(
                  text: "Witze, Funfacts...",
                  description: "Werden nicht an jedem Tag angezeigt",
                  action: () {
                    setState(() {
                      BrainApp.updatePreference("showMediaBox", !BrainApp.preferences["showMediaBox"]);
                      BrainApp.notifier.notifyOfChanges();
                    });
                  },
                  state: BrainApp.preferences["showMediaBox"],
                ),
                SettingsSwitchButton(
                  text: "Endzeiten eines Fachs",
                  description: "Ob auf der Übersicht auch das Ende einer Stunde angezeigt werden soll",
                  action: () {
                    setState(() {
                      BrainApp.updatePreference("showLessonEndTimes", !BrainApp.preferences["showLessonEndTimes"]);
                      BrainApp.notifier.notifyOfChanges();
                    });
                  },
                  state: BrainApp.preferences["showLessonEndTimes"],
                )
              ]
            )
          ]
        )
    );
  }
}

class IconRadio extends StatelessWidget {
  const IconRadio({
    Key? key,
    required this.isSelected,
    required this.design,
    required this.tooltip
  }) : super(key: key);

  final bool isSelected;
  final String tooltip;
  final Design design;

  String colorToString(Color color) {
    return "#" + color.value.toRadixString(16);
  }

  Widget getSvgIcon(BuildContext context) {
    DesignPackage designPackage;
    if (BrainApp.preferences["darkMode"]) {
      designPackage = design.darkVariant;
    } else {
      designPackage = design.lightVariant;
    }

    bool isDesktop = MediaQuery.of(context).size.width > AppDesign.breakPointWidth;

    Color primaryColor = design.runtimeType == MonochromeDesign
        ? Color(BrainApp.preferences["overridePrimaryWith"])
        : designPackage.colors.primary;

    // Replace text color
    String themeIcon = (isDesktop ? desktopThemeIconSvg : themeIconSvg).replaceAll("#303540", colorToString(designPackage.colors.text));
    // Replace primaryColor
    themeIcon = themeIcon.replaceAll("#9B9B9B", colorToString(primaryColor));
    // Replace backgroundColor
    themeIcon = themeIcon.replaceAll("#F1F1F1", colorToString(designPackage.colors.background));
    // Replace boxBackground
    themeIcon = themeIcon.replaceAll("white", colorToString(designPackage.colors.secondaryBackground));

    return SvgPicture.string(
      themeIcon,
      width: isDesktop ? 90 : 45,
      height: isDesktop ? 50 : 55)
    ;
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > AppDesign.breakPointWidth;

    return Tooltip(
      message: tooltip,
      child: Container(
        width: isDesktop ? 95: 50,
        height: isDesktop ? 65 : 70,
        decoration: BoxDecoration(
            color: isSelected ? AppDesign.colors.primary.withOpacity(0.3) : null,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: getSvgIcon(context),
        ),
      ),
    );
  }
}
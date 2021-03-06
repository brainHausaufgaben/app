import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/theming_utilities.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      radios.add(IconRadio(isSelected: radioList[index], design: value, tooltip: key));
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
                action: () => NavigationHelper.pushNamed(context, "timeTable")
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Design Einstellungen",
                action: () => NavigationHelper.pushNamed(context, "designSettings")
              )
            ]
          ),
          SettingsEntry(
            children: [
              SettingsSwitchButton(
                text: "Witze, Funfacts...",
                description: "Wird nicht an jedem Tag angezeigt!",
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
                text: "??ber die App",
                action: () => showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                    applicationName: "Brain Hausaufgaben App",
                    applicationVersion: "0.5",
                    applicationIcon: Image.asset("icons/appIcon.jpg", width: 60, height: 60),
                    children: [
                      Text("Entwickler: Sebastian Merk, Manuel Murmann"),
                      Text("Designer: Manuel Murmann"),
                      Text("Project Manager: David Will")
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

  Widget getSvgIcon() {
    DesignPackage designPackage;
    if (BrainApp.preferences["darkMode"]) {
      designPackage = design.darkVariant;
    } else {
      designPackage = design.lightVariant;
    }

    // Replace text color
    String themeIcon = themeIconSvg.replaceAll("#303540", colorToString(designPackage.textStyles.color));
    // Replace primaryColor
    themeIcon = themeIcon.replaceAll("#9B9B9B", colorToString(designPackage.primaryColor));
    // Replace backgroundColor
    themeIcon = themeIcon.replaceAll("#F1F1F1", colorToString(designPackage.themeData.scaffoldBackgroundColor));
    // Replace boxBackground
    themeIcon = themeIcon.replaceAll("white", colorToString(designPackage.boxStyle.backgroundColor));

    return SvgPicture.string(themeIcon, width: 45, height: 55);
  }

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
          child: getSvgIcon(),
        ),
      ),
    );
  }
}
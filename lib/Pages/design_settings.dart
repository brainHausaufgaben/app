import 'package:brain_app/Backend/theming_utilities.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';

class DesignSettingsPage extends StatefulWidget {
  const DesignSettingsPage({Key? key}) : super(key: key);

  @override
  State<DesignSettingsPage> createState() => _DesignSettingsPage();
}

class _DesignSettingsPage extends State<DesignSettingsPage> {
  final List<bool> radioList = List.filled(Design.allDesigns.length, false);
  String version = "...";

  @override
  void initState() {
    super.initState();
    radioList[Design.allDesigns.keys.toList().indexOf(BrainApp.preferences["design"])] = true;
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
        title: "Design Einstellungen",
        subtitle: "Version " + version,
        backButton: true,
        child: SettingsEntry(
            children: [
              SettingsSwitchButton(
                text: "Darkmode",
                action: () => AppDesign.toggleDarkMode(),
                state: BrainApp.preferences["darkMode"],
              ),
              getThemeChooser()
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
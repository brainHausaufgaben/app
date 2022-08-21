import 'package:brain_app/Backend/design.dart';
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
                  builder: (context) => Dialog(
                    backgroundColor: AppDesign.colors.secondaryBackground,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppDesign.colors.background,
                              borderRadius: AppDesign.boxStyle.inputBorderRadius
                            ),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Center(
                                    child: Image.asset("icons/appIcon.jpg", width: 60, height: 60),
                                  ),
                                ),
                                Flexible(child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Brain Hausaufgabenheft", style: AppDesign.textStyles.boxHeadline),
                                        Text("Version ${BrainApp.appVersion}", style: AppDesign.textStyles.pointElementSecondary)
                                      ]
                                  ),
                                ))
                              ]
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Entwickler: Sebastian Merk, Manuel Murmann",
                                  style: TextStyle(
                                      color: AppDesign.colors.text,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "Designer: Manuel Murmann",
                                    style: TextStyle(
                                        color: AppDesign.colors.text,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15
                                    ),
                                  ),
                                ),
                                Text(
                                  "Project Manager: David Will (aber nicht wirklich)",
                                  style: TextStyle(
                                      color: AppDesign.colors.text,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15
                                  )
                                )
                              ]
                            )
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppDesign.colors.primary,
                              primary: AppDesign.colors.contrast,
                              padding: const EdgeInsets.symmetric(vertical: 13)
                            ),
                            child: Text(
                              "Lizenzen",
                              style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)
                            ),
                            onPressed: () => showLicensePage(context: context),
                          )
                        ]
                      )
                    )
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
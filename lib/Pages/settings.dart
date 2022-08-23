import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
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
              SettingsSwitchButton(
                text: "Oberstufe",
                action: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                        title: Text(
                            "Bist du sicher?",
                            style: AppDesign.textStyles.alertDialogHeader
                        ),
                        backgroundColor: AppDesign.colors.secondaryBackground,
                        content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Diese Aktion wird alle Noten von diesem Jahr löschen. Du solltest, falls noch nicht geschehen, erst ein neues Schuljahr setzen",
                                style: AppDesign.textStyles.alertDialogDescription,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 5),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: AppDesign.colors.primary,
                                        primary: AppDesign.colors.contrast,
                                        padding: const EdgeInsets.symmetric(vertical: 12)
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                        "Abbrechen",
                                        style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)
                                    )
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      side: BorderSide(color: AppDesign.colors.primary, width: 2),
                                      primary: AppDesign.colors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 12)
                                  ),
                                  onPressed: () {
                                    GradingSystem.setAdvancedLevel(!GradingSystem.isAdvancedLevel);
                                    BrainApp.notifier.notifyOfChanges();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      "Fortfahren",
                                      style: AppDesign.textStyles.buttonText.copyWith(
                                          fontSize: 16,
                                          color: AppDesign.colors.primary
                                      )
                                  )
                              )
                            ]
                        )
                    );
                  }
                ),
                state: GradingSystem.isAdvancedLevel,
              )
            ]
          ),
          if (kIsWeb) SettingsEntry(
            children: [
              SettingsNavigatorButton(
                text: "Tastenkürzel",
                action: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Tastenkürzel",
                        style: AppDesign.textStyles.alertDialogHeader
                      ),
                      content: Wrap(
                        direction: Axis.vertical,
                        spacing: 8,
                        children: [
                          Text(
                            "Shift + H: Neue Hausaufgabe",
                            style: AppDesign.textStyles.pointElementPrimary
                          ),
                          Text(
                              "Shift + T: Stundenplan",
                              style: AppDesign.textStyles.pointElementPrimary
                          )
                        ]
                      )
                    );
                  }
                )
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
              if (BrainApp.preferences["showDeveloperOptions"]) SettingsNavigatorButton(
                text: "Developer Options",
                action: () {
                  NavigationHelper.pushNamed(context, "developerOptions");
                },
              ),
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
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Brain Hausaufgabenheft", style: AppDesign.textStyles.boxHeadline),
                                        Text("Version ${BrainApp.appVersion}", style: AppDesign.textStyles.pointElementSecondary)
                                      ]
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Entwickler: Sebastian Merk, Manuel Murmann",
                                  style: AppDesign.textStyles.pointElementPrimary
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "Designer: Manuel Murmann",
                                    style: AppDesign.textStyles.pointElementPrimary
                                  ),
                                ),
                                Text(
                                  "Project Manager: David Will (aber nicht wirklich)",
                                  style: AppDesign.textStyles.pointElementPrimary
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
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Components/brain_confirmation_dialog.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    return BrainConfirmationDialog(
                      description: "Diese Aktion wird alle Noten von diesem Jahr löschen. Du solltest, falls noch nicht geschehen, erst deine Klasse ändern",
                      onCancel: () => Navigator.of(context).pop(),
                      onContinue: () {
                        GradingSystem.setAdvancedLevel(!GradingSystem.isAdvancedLevel);
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.of(context).pop();
                      }
                    );
                  }
                ),
                state: GradingSystem.isAdvancedLevel,
              ),
              SettingsNumberPicker(
                minValue: 5,
                maxValue: 13,
                dialogTitle: "Wähle deine Klasse",
                text: "Klasse",
                currentValue: GradingSystem.currentYear,
                action: (value) {
                  GradingSystem.setCurrentYear(value);
                  BrainApp.notifier.notifyOfChanges();
                },
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
                            "Alt + H: Neue Hausaufgabe",
                            style: AppDesign.textStyles.pointElementPrimary
                          ),
                          Text(
                            "Alt + S: Stundenplan",
                            style: AppDesign.textStyles.pointElementPrimary
                          ),
                          Text(
                            "Alt + N: Neue Note",
                            style: AppDesign.textStyles.pointElementPrimary
                          ),
                          Text(
                            "Alt + E: Neues Event",
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
                                    child: Image.asset("icons/Icon-192.png", width: 60, height: 60),
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
                              foregroundColor: AppDesign.colors.contrast,
                              backgroundColor: AppDesign.colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 13)
                            ),
                            child: Text(
                                "Datenschutz",
                                style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)
                            ),
                            onPressed: () {
                              Uri uri = Uri.parse("https://brain-hausaufgabenheft.de/datenschutz");
                              launchUrl(uri, mode: LaunchMode.externalApplication);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppDesign.colors.text,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                side: BorderSide(color: AppDesign.colors.text, width: 2)
                              ),
                              child: Text(
                                  "Lizenzen",
                                  style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16, color: AppDesign.colors.text)
                              ),
                              onPressed: () => showLicensePage(context: context),
                            ),
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
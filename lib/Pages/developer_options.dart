import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({Key? key}) : super(key: key);

  static int timesClicked = 0;
  static DateTime lastClick = DateTime.now();

  @override
  State<DeveloperOptionsPage> createState() => _DeveloperOptionsPage();
}

class _DeveloperOptionsPage extends State<DeveloperOptionsPage> with SingleTickerProviderStateMixin {
  late AnimationController noBitchesController;

  @override
  void initState() {
    noBitchesController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    noBitchesController.dispose();
    super.dispose();
  }

  Future noBitches() async {
    showDialog(context: context, builder: (context) {
      noBitchesController.forward();
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: noBitchesController,
          curve: Curves.fastOutSlowIn
        ),
        child: RotationTransition(
          turns: CurvedAnimation(
              parent: noBitchesController,
              curve: Curves.fastOutSlowIn
          ),
          child: Image(
            image: const AssetImage("images/compiled html asset.png"),
            width: MediaQuery.of(context).size.width,
          ),
        ),
      );
    }).then((value) => noBitchesController.reset());
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Developer Options",
      subtitle: "Spezifische Einstellungen für die Entwickler",
      backButton: true,
      pageSettings: const PageSettings(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFB40000), width: 3),
                    primary: const Color(0xFFB40000),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15)
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                          title: Text(
                            "Willst du die App wirklich zurücksetzen?",
                            style: AppDesign.textStyles.alertDialogHeader
                          ),
                          backgroundColor: AppDesign.colors.secondaryBackground,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Diese Aktion wird alle Einstellungen sowie dein Stundenplan, deine Noten etc. löschen",
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
                                  BrainApp.clearPreferences();
                                  //TODO: Local storage leer machen (sese)
                                  Navigator.of(context).pop();
                                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
                    );
                  },
                  child: Text("App zurücksetzen", style: AppDesign.textStyles.buttonText.copyWith(color: const Color(0xFFB40000)))
              )
            )
          ]
        )
      ),
      child: Wrap(
        runSpacing: 10,
        children: [
          SettingsEntry(
            children: [
              SettingsTextfield(
                text: "Developer Code",
                submitAction: (text) {
                  if (text == "no bitches?") {
                    noBitches().then((value) {
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    });
                  } else {
                    DeveloperOptions.enterText(text);
                  }
                }
              )
            ]
          )
        ]
      )
    );
  }
}
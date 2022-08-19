import 'dart:html';
import 'dart:io';

import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/foundation.dart';
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
    await Future.delayed(const Duration(seconds: 3));
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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: const Color(0xFFB40000),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15)
                  ),
                  onPressed: () {
                    BrainApp.clearPreferences();
                    //TODO: Local storage leer machen (sese)
                  },
                  child: Text("App zurücksetzen", style: AppDesign.current.textStyles.buttonText)
              ),
            )
          ],
        ),
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
                      if (kIsWeb) {
                        window.close();
                      } else {
                        SystemNavigator.pop();
                      }
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
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Components/brain_confirmation_dialog.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/headline_wrap.dart';


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

  List<Widget> getDeveloperOptions(){
    List<Widget> widgets = [];

    for(String code in DeveloperOptions.activatedCodes){
      List<dynamic>? result = DeveloperOptions.codes[code.toLowerCase().trim()];
      if(result != null){
        widgets.add(
        SettingsEntry(
            children: [
              SettingsNavigatorButton(
                  text: result[1],
                  description: result[2],
                  action: () => (result[0] as Function).call()
              )
            ]
        ));
      }
    }
    return widgets;
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
                    primary: Colors.white,
                    backgroundColor: const Color(0xFFB40000),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15)
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BrainConfirmationDialog(
                          description: "Diese Aktion wird alle Einstellungen sowie dein Stundenplan, deine Noten etc. löschen",
                          onContinue: () {
                            BrainApp.clearPreferences();
                            SaveSystem.storage.clear();
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          },
                          onCancel: () => Navigator.of(context).pop()
                        );
                      }
                    );
                  },
                  child: Text("App zurücksetzen", style: AppDesign.textStyles.buttonText.copyWith(color: Colors.white))
              )
            )
          ]
        )
      ),
      floatingHeader: SettingsEntry(
          children: [
            SettingsTextField(
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
      ),
      child: HeadlineWrap(
        headline: 'Funktionen',
        children: getDeveloperOptions()
      )
    );
  }
}
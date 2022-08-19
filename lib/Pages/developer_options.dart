import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';


class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({Key? key}) : super(key: key);

  @override
  State<DeveloperOptionsPage> createState() => _DeveloperOptionsPage();
}

class _DeveloperOptionsPage extends State<DeveloperOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Developer Options",
      subtitle: "Spezifische Einstellungen für die Entwickler",
      backButton: true,
      child: Wrap(
        runSpacing: 10,
        children: [
          SettingsEntry(
            children: [
              SettingsTextfield(
                text: "Developer Code",
                submitAction: (text) {
                  DeveloperOptions.enterText(text);}
              )
            ]
          )
        ]
      )
    );
  }
}
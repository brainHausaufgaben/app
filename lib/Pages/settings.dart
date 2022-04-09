import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Einstellungen",
      subtitle: "Version xx.xx",
      backButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: CustomSettingsButton(
              text: "Stundenplan",
              action: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTablePage()));
              },
            ),
          ),
          CustomSettingsButton(
            text: "Darkmode",
            action: () {
              currentDesign.toggleDarkMode();
              currentDesign.toggleTheme("monochromeTheme");
            },
          )
        ],
      )
    );
  }
}
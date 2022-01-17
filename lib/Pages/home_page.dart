import 'package:brain_app/Box.dart';
import 'package:flutter/material.dart';
import 'page_template.dart';
import '../Components/warning_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: 'Übersicht',
        child: Column(
          children: [
            WarningBox(
                text: "Du hast noch unerledigte Hausaufgaben in 2 Fächern",
                iconIndex: 0
            ),
            const Box()
          ],
        )
    );
  }
} 
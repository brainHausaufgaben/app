import 'package:brain_app/Box.dart';
import 'package:brain_app/Components/point_element.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WarningBox(
                text: "Du hast noch unerledigte Hausaufgaben in 2 Fächern",
                iconIndex: 0
            ),
            const Text(
              "Stundenplan Heute",
              style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600, fontSize:24, height: 0.6
              ),
            ),
             Box(child: PointElement(child: Text("okok"),color: Colors.pink,primaryText: "aa",secondaryText: "Ja",))
          ],
        )
    );
  }
} 
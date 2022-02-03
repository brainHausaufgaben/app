import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Box.dart';
import 'package:brain_app/Components/home_page_day.dart';
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
            HomePageDay(day:DateTime.now().weekday, headline: "Stundenplan Heute",),
            HomePageDay(day:DateTime.now().weekday + 1, headline: "Stundenplan Morgen",),
          ],
        )
    );
}

} 
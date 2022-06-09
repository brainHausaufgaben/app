import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/subject_page.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class SubjectOverview extends StatefulWidget {
  const SubjectOverview({Key? key}) : super(key: key);

  @override
  State<SubjectOverview> createState() => _SubjectOverview();
}

class _SubjectOverview extends State<SubjectOverview> {
  List<CustomIconButton> initSubjectButtons() {
    List<CustomIconButton> buttons = [];
    for (Subject subject in TimeTable.subjects) {
      buttons.add(CustomIconButton(
        child: PointElement(
          primaryText: subject.name,
          color: subject.color,
        ),
        icon: Icons.edit,
        dense: true,
        action: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubjectPage(previous: subject))
          ).then((value) {
            setState(() {});
          });
        },
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Alle Fächer",
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubjectPage())
          ).then((value) {
            setState(() {});
          });
        }
      ),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 5,
          children: initSubjectButtons(),
        ),
      ),
      backButton: true,
    );
  }
}
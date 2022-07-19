import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
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
  List<BrainIconButton> getSubjectButtons() {
    List<BrainIconButton> buttons = [];
    for (Subject subject in TimeTable.subjects) {
      buttons.add(BrainIconButton(
        child: PointElement(
          primaryText: subject.name,
          color: subject.color,
        ),
        icon: Icons.edit,
        dense: true,
        action: () => NavigationHelper.push(SubjectPage(previousSubject: subject))
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
        onPressed: () => NavigationHelper.pushNamed("/settings/timetable/subjectPage")
      ),
      child: Wrap(
        runSpacing: 5,
        children: getSubjectButtons(),
      ),
      backButton: true,
    );
  }
}
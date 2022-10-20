import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class SubjectOverview extends StatefulWidget {
  const SubjectOverview({Key? key}) : super(key: key);

  @override
  State<SubjectOverview> createState() => _SubjectOverview();
}

class _SubjectOverview extends State<SubjectOverview> {
  List<BrainButton> getSubjectButtons() {
    List<BrainButton> buttons = [];
    for (Subject subject in TimeTable.subjects) {
      buttons.add(BrainButton(
        centered: false,
        icon: Icons.edit,
        dense: true,
        action: () => NavigationHelper.pushNamed(context, "subjectPage", payload: subject),
        child: PointElement(
          primaryText: subject.name,
          color: subject.color,
        )
      ));
    }
    return buttons;
  }

  List<BrainButton> getLinkedSubjectButtons() {
    List<BrainButton> buttons = [];
    for (Subject subject in TimeTable.linkedSubjects) {
      buttons.add(BrainButton(
          centered: false,
          icon: Icons.edit,
          dense: true,
          action: () => NavigationHelper.pushNamed(context, "subjectPage", payload: subject),
          child: PointElement(
            primaryText: subject.name,
            color: subject.color,
          )
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Alle Fächer",
      floatingActionButton: BrainMenuButton(
        defaultAction: () => NavigationHelper.pushNamed(context, "subjectPage"),
        defaultLabel: "Neues Fach",
        icon: Icons.add,
        withEntries: false,
      ),
      backButton: true,
      child: Wrap(
        runSpacing: 20,
        children: [
          if (TimeTable.linkedSubjects.isNotEmpty) HeadlineWrap(
              headline: "Verbindungen",
              children: getLinkedSubjectButtons()
          ),
          if (TimeTable.subjects.isNotEmpty) HeadlineWrap(
            headline: "Fächer",
            children: getSubjectButtons()
          )
        ]
      )
    );
  }
}
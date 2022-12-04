import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/grades_box.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

import 'Primary Pages/grades.dart';

class GradesPerSubjectPage extends StatefulWidget {
  const GradesPerSubjectPage({Key? key}): super(key: key);

  @override
  State<GradesPerSubjectPage> createState() => _GradesPerSubjectPage();
}

class _GradesPerSubjectPage extends State<GradesPerSubjectPage>{
  Subject? subject;
  LinkedSubject? linkedSubject;

  List<int> get partsOfYear => GradeOverview.timeSelectors.value == TimeSelectors.thisYear ? [1, 2, 3] : [GradeOverview.timeSelectors.value.index];
  late Function() listener;

  List<Widget> getShortTests(Subject subject) {
    List<Widget> buttons = [];

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(subject, onlyPartsOfYear: partsOfYear)) {
      if (grade.type != GradeType.smallTest) continue;
      buttons.add(
          BrainButton(
            dense: true,
            centered: false,
            icon: Icons.edit,
            action: () => NavigationHelper.pushNamed(context, "gradesPage", payload: grade),
            child: PointElement(
              color: subject.color,
              primaryText: grade.name,
              child: Text(
                GradingSystem.isAdvancedLevel
                    ? "${grade.value.toInt()} Punkt${grade.value.toInt() == 1 ? "" : "e"}"
                    : "Note ${grade.value.toString()}",
                style: AppDesign.textStyles.pointElementSecondary
              )
            )
          )
      );
    }

    return buttons;
  }

  List<Widget> getOral(Subject subject) {
    List<Widget> buttons = [];

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(subject, onlyPartsOfYear: partsOfYear)) {
      if (grade.type != GradeType.oralGrade) continue;
      buttons.add(
          BrainButton(
            centered: false,
            dense: true,
            icon: Icons.edit,
            action: () => NavigationHelper.pushNamed(context, "gradesPage", payload: grade),
            child: PointElement(
              color: subject.color,
              primaryText: grade.name,
              child: Text(
                GradingSystem.isAdvancedLevel
                    ? "${grade.value.toInt()} Punkt${grade.value.toInt() == 1 ? "" : "e"}"
                    : "Note ${grade.value.toString()}",
                style: AppDesign.textStyles.pointElementSecondary
              )
            )
          )
      );
    }

    return buttons;
  }

  List<Widget> getTests(Subject subject) {
    List<Widget> buttons = [];

    for (BigGrade grade in GradingSystem.getBigGradesBySubject(subject, onlyPartsOfYear: partsOfYear)) {
      buttons.add(
          BrainButton(
            dense: true,
            centered: false,
            icon: Icons.edit,
            action: () {
              if (GradingSystem.isAdvancedLevel == grade.time.isAdvancedLevel) {
                NavigationHelper.pushNamed(context, "gradesPage", payload: grade);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                      title: Text("Nicht änderbar", style: AppDesign.textStyles.alertDialogHeader),
                      content: Text(
                        "Diese Note wurde in der ${grade.time.isAdvancedLevel ? "Oberstufe" : "Unterstufe"} hinzugefügt, "
                            "während du dich in der ${GradingSystem.isAdvancedLevel ? "Oberstufe" : "Unterstufe"} befindest",
                        style: AppDesign.textStyles.alertDialogDescription
                      )
                    );
                  }
                );
              }
            },
            child: PointElement(
              color: subject.color,
              primaryText: grade.name,
              child: Text(
                GradingSystem.isAdvancedLevel
                    ? "${grade.value.toInt()} Punkt${grade.value.toInt() == 1 ? "" : "e"}"
                    : "Note ${grade.value.toStringAsFixed(2)}",
                style: AppDesign.textStyles.pointElementSecondary
              )
            )
          )
      );
    }

    return buttons;
  }

  void getData() {
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    setState(() {
      switch (data.runtimeType) {
        case Subject:
          subject = ModalRoute.of(context)!.settings.arguments as Subject;
          break;
        case LinkedSubject:
          linkedSubject = ModalRoute.of(context)!.settings.arguments as LinkedSubject;
          break;
      }
    });
  }

  @override
  void initState() {
    listener = () => setState(() {});
    GradeOverview.timeSelectors.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    GradeOverview.timeSelectors.removeListener(listener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: subject?.name ?? linkedSubject!.name,
        secondaryPage: true,
        floatingActionButton: BrainMenuButton(
          defaultAction: () => NavigationHelper.pushNamed(context, "gradesPage", payload: subject ?? linkedSubject),
          defaultLabel: "Neue Note",
          icon: Icons.add,
          withEntries: false,
        ),
        floatingHeader: GradesBox(
          currentSelector: GradeOverview.timeSelectors.value,
          value: subject == null
              ? GradingSystem.getLinkedAverage(linkedSubject!, onlyPartsOfYear: partsOfYear).toStringAsFixed(2)
              : GradingSystem.getAverage(subject!, onlyPartsOfYear: partsOfYear).toStringAsFixed(2),
          onChanged: (value) {
            GradeOverview.timeSelectors.value = value;
          },
        ),
        secondaryTitleButton: TextButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                backgroundColor: AppDesign.colors.secondaryBackground,
                minimumSize: Size.zero
            ),
            onPressed: () => NavigationHelper.pushNamed(context, "subjectPage", payload: subject ?? linkedSubject),
            child: Semantics(
              label: "Fach Bearbeiten",
              child: Icon(Icons.edit, color: AppDesign.colors.text),
            )
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            runSpacing: 20,
            children: [
              if (getTests(subject ?? linkedSubject!.subjects[0]).isNotEmpty || (linkedSubject != null ? getTests(linkedSubject!.subjects[1]).isNotEmpty : false)) HeadlineWrap(
                  headline: "Schulaufgaben",
                  children: [
                    if (subject != null) ...getTests(subject!),
                    if (linkedSubject != null) ...[
                      ...getTests(linkedSubject!.subjects[0]),
                      ...getTests(linkedSubject!.subjects[1])
                    ]
                  ]
              ),
              if (getShortTests(subject ?? linkedSubject!.subjects[0]).isNotEmpty || (linkedSubject != null ? getShortTests(linkedSubject!.subjects[1]).isNotEmpty : false)) HeadlineWrap(
                  headline: "Exen",
                  children: [
                    if (subject != null) ...getShortTests(subject!),
                    if (linkedSubject != null) ...[
                      ...getShortTests(linkedSubject!.subjects[0]),
                      ...getShortTests(linkedSubject!.subjects[1])
                    ]
                  ]
              ),
              if (getOral(subject ?? linkedSubject!.subjects[0]).isNotEmpty || (linkedSubject != null ? getOral(linkedSubject!.subjects[1]).isNotEmpty : false)) HeadlineWrap(
                  headline: "Mündliche Noten",
                  children: [
                    if (subject != null) ...getOral(subject!),
                    if (linkedSubject != null) ...[
                      ...getOral(linkedSubject!.subjects[0]),
                      ...getOral(linkedSubject!.subjects[1])
                    ]
                  ]
              )
            ]
          )
        )
    );
  }
}
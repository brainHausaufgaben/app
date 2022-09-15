import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
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
  GradesPerSubjectPage({Key? key}): super(key: key);

  late Subject subject;

  @override
  State<GradesPerSubjectPage> createState() => _GradesPerSubjectPage();
}

class _GradesPerSubjectPage extends State<GradesPerSubjectPage>{
  List<int> get partsOfYear => GradeOverview.timeSelectors.value == TimeSelectors.thisYear ? [1, 2, 3] : [GradeOverview.timeSelectors.value.index];
  late Function() listener;

  List<Widget> getShortTests() {
    List<Widget> buttons = [];

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(widget.subject, onlyPartsOfYear: partsOfYear)) {
      if (grade.type != GradeType.smallTest) continue;
      buttons.add(
          BrainIconButton(
            dense: true,
            child: PointElement(
              color: widget.subject.color,
              primaryText: grade.name,
              child: Text(
                GradingSystem.isAdvancedLevel
                    ? "${grade.value.toInt()} Punkt${grade.value.toInt() == 1 ? "" : "e"}"
                    : "Note ${grade.value.toString()}",
                style: AppDesign.textStyles.pointElementSecondary
              )
            ),
            icon: Icons.edit,
            action: () => NavigationHelper.pushNamed(context, "gradesPage", payload: grade),
          )
      );
    }

    return buttons;
  }

  List<Widget> getOral() {
    List<Widget> buttons = [];

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(widget.subject, onlyPartsOfYear: partsOfYear)) {
      if (grade.type != GradeType.oralGrade) continue;
      buttons.add(
          BrainIconButton(
            dense: true,
            child: PointElement(
              color: widget.subject.color,
              primaryText: grade.name,
              child: Text(
                GradingSystem.isAdvancedLevel
                    ? "${grade.value.toInt()} Punkt${grade.value.toInt() == 1 ? "" : "e"}"
                    : "Note ${grade.value.toString()}",
                style: AppDesign.textStyles.pointElementSecondary
              )
            ),
            icon: Icons.edit,
            action: () => NavigationHelper.pushNamed(context, "gradesPage", payload: grade),
          )
      );
    }

    return buttons;
  }

  List<Widget> getTests() {
    List<Widget> buttons = [];

    for (BigGrade grade in GradingSystem.getBigGradesBySubject(widget.subject, onlyPartsOfYear: partsOfYear)) {
      buttons.add(
          BrainIconButton(
            dense: true,
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
              color: widget.subject.color,
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
    setState(() {
      widget.subject = ModalRoute.of(context)!.settings.arguments as Subject;
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
  Widget build(BuildContext context) {
    getData();

    return PageTemplate(
        title: widget.subject.name,
        backButton: true,
        floatingActionButton: BrainMenuButton(
          defaultAction: () => NavigationHelper.pushNamed(context, "gradesPage", payload: widget.subject),
          defaultLabel: "Neue Note",
          icon: Icons.add,
          withEntries: false,
        ),
        floatingHeader: GradesBox(
          currentSelector: GradeOverview.timeSelectors.value,
          value: GradingSystem.getAverage(widget.subject, onlyPartsOfYear: partsOfYear).toStringAsFixed(2),
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
            onPressed: () => NavigationHelper.pushNamed(context, "subjectPage", payload: widget.subject),
            child: Semantics(
              label: "Fach Bearbeiten",
              child: Icon(Icons.edit, color: AppDesign.colors.text),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            runSpacing: 20,
            children: [
              if (getTests().isNotEmpty) HeadlineWrap(
                  headline: "Schulaufgaben",
                  children: getTests()
              ),
              if (getShortTests().isNotEmpty) HeadlineWrap(
                  headline: "Exen",
                  children: getShortTests()
              ),
              if (getOral().isNotEmpty) HeadlineWrap(
                  headline: "Mündliche Noten",
                  children: getOral()
              )
            ],
          ),
        )
    );
  }
}
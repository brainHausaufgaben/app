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
              primaryText: "1. Exemporale",
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
              primaryText: "1. Mündliche Note",
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
            child: PointElement(
              color: widget.subject.color,
              primaryText: "1. Schulaufgabe",
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
          value: GradingSystem.getAverage(widget.subject, onlyPartsOfYear: partsOfYear).toString(),
          onChanged: (value) {
            GradeOverview.timeSelectors.value = value;
          },
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
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
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import 'Primary Pages/grades.dart';

class GradesPerSubjectPage extends StatefulWidget {
  GradesPerSubjectPage({Key? key}): super(key: key);

  late Subject subject;

  @override
  State<GradesPerSubjectPage> createState() => _GradesPerSubjectPage();
}

class _GradesPerSubjectPage extends State<GradesPerSubjectPage>{
  List<int> get partsOfYear => GradeOverview.timeSelectors == TimeSelectors.thisYear ? [1, 2, 3] : [GradeOverview.timeSelectors.index];

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
          currentSelector: GradeOverview.timeSelectors,
          value: GradingSystem.getAverage(widget.subject, onlyPartsOfYear: partsOfYear).toString(),
          onChanged: (value) {
            GradeOverview.timeSelectors = value;
            BrainApp.notifier.notifyOfChanges();
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

class GradeWidget extends StatelessWidget {
  GradeWidget({
    Key? key,
    required this.name,
    required this.value,
    required this.reversed
  }) : super(key: key);

  final String name;
  final String value;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 8,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: AppDesign.boxStyle.borderRadius,
                color: AppDesign.colors.secondaryBackground
            ),
            child: Center(
                child: Wrap(
                    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                          value,
                          style: TextStyle(
                              color: AppDesign.colors.text,
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          )
                      ),
                      Text(
                          name,
                          style: TextStyle(
                              color: AppDesign.colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w700
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class GradesPerSubjectPage extends StatefulWidget {
  GradesPerSubjectPage({Key? key}): super(key: key);

  late Subject subject;

  @override
  State<GradesPerSubjectPage> createState() => _GradesPerSubjectPage();
}

class _GradesPerSubjectPage extends State<GradesPerSubjectPage>{
  List<Widget> getShortTests() {
    List<Widget> buttons = [];

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(widget.subject)) {
      if (grade.type != GradeType.smallTest) continue;
      buttons.add(
          BrainIconButton(
            dense: true,
            child: PointElement(
              color: widget.subject.color,
              primaryText: "1. Exemporale",
              child: Text(grade.value.toString(), style: AppDesign.current.textStyles.pointElementSecondary),
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

    for (SmallGrade grade in GradingSystem.getSmallGradesBySubject(widget.subject)) {
      if (grade.type != GradeType.oralGrade) continue;
      buttons.add(
          BrainIconButton(
            dense: true,
            child: PointElement(
              color: widget.subject.color,
              primaryText: "1. Mündliche Note",
              child: Text(grade.value.toString(), style: AppDesign.current.textStyles.pointElementSecondary),
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

    for (BigGrade grade in GradingSystem.getBigGradesBySubject(widget.subject)) {
      buttons.add(
          BrainIconButton(
            dense: true,
            child: PointElement(
              color: widget.subject.color,
              primaryText: "1. Schulaufgabe",
              child: Text(grade.value.toString(), style: AppDesign.current.textStyles.pointElementSecondary),
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
        floatingHeader: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15
          ),
          decoration: BoxDecoration(
              color: AppDesign.current.primaryColor,
              borderRadius: AppDesign.current.boxStyle.borderRadius
          ),
          child: Flex(
              direction: Axis.horizontal,
              children: [
                GradeWidget(
                  name: GradingSystem.getAverage(widget.subject).round() == 1 ? "Punkt" : "Punkte",
                  value: (){
                    if(GradingSystem.getAverage(widget.subject) == -1) {
                      return "-";
                    } else {
                      return GradingSystem.getAverage(widget.subject).round().toString();
                    }
                  }(),
                  reversed: false,
                ),
                const Spacer(flex: 1),
                GradeWidget(
                  name: "Note",
                  value: GradingSystem.PointToGrade(GradingSystem.getAverage(widget.subject).round()),
                  reversed: true,
                )
              ]
          ),
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
                borderRadius: AppDesign.current.boxStyle.borderRadius,
                color: AppDesign.current.boxStyle.backgroundColor
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
                              color: AppDesign.current.textStyles.color,
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          )
                      ),
                      Text(
                          name,
                          style: TextStyle(
                              color: AppDesign.current.textStyles.color,
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
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/grades_per_subject_page.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Pages/page_template.dart';

class GradeOverview extends StatefulWidget {
  const GradeOverview({Key? key}): super(key: key);

  @override
  State<GradeOverview> createState() => _GradeOverview();
}

class _GradeOverview extends State<GradeOverview>{
  List<Widget> getGradeButtons() {
    List<Widget> buttons = [];

    for (Subject subject in TimeTable.subjects) {
      double average = GradingSystem.getAverage(subject);
      buttons.add(
        CustomIconButton(
          dense: true,
          child: PointElement(
            color: subject.color,
            primaryText: subject.name,
            child: Text(average == -1.0 ? "Noch keine Noten" : "${average.toInt()} Punkte", style: AppDesign.current.textStyles.pointElementSecondary),
          ),
          icon: Icons.edit,
          action: () => NavigationHelper.navigator.push(
            MaterialPageRoute(builder: (context) => GradesPerSubjectPage(subject: subject))
          ),
        )
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Noten',
      floatingActionButton: CustomMenuButton(
          defaultAction: () => NavigationHelper.pushNamed("/gradesPage")
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
                name: GradingSystem.getYearAverage().round() == 1 ? "Punkt" : "Punkte",
                value: GradingSystem.getYearAverage().round().toString(),
                reversed: false,
              ),
              const Spacer(flex: 1),
              GradeWidget(
                name: "Note",
                value: GradingSystem.PointToGrade(GradingSystem.getYearAverage().round()),
                reversed: true,
              )
            ]
        ),
      ),
      child: HeadlineWrap(
        headline: "Alle Noten",
        children: getGradeButtons()
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
                color: AppDesign.current.themeData.scaffoldBackgroundColor
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
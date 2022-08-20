import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:flutter/material.dart';

class CollapsibleGradesBox extends StatelessWidget {
  const CollapsibleGradesBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppDesign.colors.primary,
            borderRadius: AppDesign.boxStyle.borderRadius
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                boxShadow: [
                  AppDesign.boxStyle.boxShadow
                ],
                color: AppDesign.colors.background
            ),
            child: Center(
                child: Wrap(
                    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                            color: AppDesign.colors.text,
                            fontSize: 25,
                            fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            color: AppDesign.colors.text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.center
                      )
                    ]
                )
            )
        )
    );
  }
}
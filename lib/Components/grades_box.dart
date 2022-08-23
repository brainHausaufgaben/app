import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:flutter/material.dart';

enum TimeSelectors {
  thisYear,
  firstSemester,
  secondSemester,
  thirdSemester
}

class GradesBox extends StatelessWidget {
  const GradesBox({
    Key? key,
    required this.currentSelector,
    required this.onChanged,
    required this.value
  }) : super(key: key);

  final TimeSelectors currentSelector;
  final Function(dynamic) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppDesign.colors.primary,
            borderRadius: AppDesign.boxStyle.borderRadius
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Durchschnitt",
                        style: TextStyle(
                          color: AppDesign.colors.contrast07,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.7,
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13, top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            value == "-1.0" ? "-" : value,
                            style: TextStyle(
                              color: AppDesign.colors.contrast,
                              fontSize: 50,
                              fontWeight: FontWeight.w800
                            )
                          ),
                          if (GradingSystem.isAdvancedLevel) Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 8),
                            child: Text(
                              "Note ${GradingSystem.PointToGrade(double.parse(value).toInt())}",
                              style: TextStyle(
                                color: AppDesign.colors.contrast,
                                fontSize: 19,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          )
                        ]
                      )
                    ),
                    BrainDropdown(
                        defaultText: "-",
                        currentValue: currentSelector,
                        items: [
                          BrainDropdownEntry(
                              value: TimeSelectors.thisYear,
                              child: Text(
                                "Dieses Jahr",
                                style: AppDesign.textStyles.input,
                              )
                          ),
                          BrainDropdownEntry(
                              value: TimeSelectors.firstSemester,
                              child: Text(
                                "1. Semester",
                                style: AppDesign.textStyles.input,
                              )
                          ),
                          BrainDropdownEntry(
                              value: TimeSelectors.secondSemester,
                              child: Text(
                                "2. Semester",
                                style: AppDesign.textStyles.input,
                              )
                          ),
                          if (!GradingSystem.isAdvancedLevel) BrainDropdownEntry(
                              value: TimeSelectors.thirdSemester,
                              child: Text(
                                "3. Semester",
                                style: AppDesign.textStyles.input,
                              )
                          )
                        ],
                        scrollableDialog: false,
                        onChanged: onChanged,
                        dialogTitle: "Alle Noten von..."
                    )
                  ]
              ),
            ),
            Positioned(
              right: -30,
              top: -45,
              child: Icon(
                Icons.school_rounded,
                size: 150,
                color: AppDesign.colors.contrast.withOpacity(0.3)
              )
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
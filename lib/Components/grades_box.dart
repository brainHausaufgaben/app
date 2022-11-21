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
                      padding: const EdgeInsets.only(bottom: 10, top: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            value == "-1.00" || value == "-1" ? "-" : value,
                            style: TextStyle(
                              color: AppDesign.colors.contrast,
                              fontSize: 43,
                              fontWeight: FontWeight.w800
                            )
                          ),
                          if (GradingSystem.isAdvancedLevel) Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 8),
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
                                "1. Teiljahr",
                                style: AppDesign.textStyles.input,
                              )
                          ),
                          BrainDropdownEntry(
                              value: TimeSelectors.secondSemester,
                              child: Text(
                                "2. Teiljahr",
                                style: AppDesign.textStyles.input,
                              )
                          ),
                          if (!GradingSystem.isAdvancedLevel) BrainDropdownEntry(
                              value: TimeSelectors.thirdSemester,
                              child: Text(
                                "3. Teiljahr",
                                style: AppDesign.textStyles.input,
                              )
                          )
                        ],
                        onChanged: onChanged,
                        dialogTitle: "Alle Noten von..."
                    )
                  ]
              ),
            ),
            Positioned(
              right: -30,
              top: -50,
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
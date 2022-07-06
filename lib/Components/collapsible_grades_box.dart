import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';

class CollapsibleGradesBox extends StatelessWidget {
  final bool collapsed;
  final Function() onTap;

  const CollapsibleGradesBox({
    Key? key,
    required this.collapsed,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
            color: AppDesign.current.primaryColor,
            borderRadius: AppDesign.current.boxStyle.borderRadius
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Wrap(
          runSpacing: 15,
          children: [
            AnimatedContainer(
              child: Text(
                collapsed ? "" : "Die Noten von allen 13 Fächern zusammengerechnet ergeben einen Schnitt von:",
                style: AppDesign.current.textStyles.collapsibleTextContrast,
                textAlign: TextAlign.center,
              ),
              duration: const Duration(seconds: 1),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                GradeWidget(
                  name: "Punkte",
                  number: 12,
                  reversed: false,
                ),
                const Spacer(flex: 1),
                GradeWidget(
                  name: "Note",
                  number: 2,
                  reversed: true,
                )
              ]
            )
          ]
        )
      )
    );
  }
}

class GradeWidget extends StatelessWidget {
  GradeWidget({
    Key? key,
    required this.name,
    required this.number,
    required this.reversed
  }) : super(key: key);

  final String name;
  final int number;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 8,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: AppDesign.current.boxStyle.borderRadius,
                boxShadow: [
                  AppDesign.current.boxStyle.boxShadow
                ],
                gradient: const LinearGradient(
                    colors: [
                      Color(0xFF22A66E),
                      Color(0xFF1C6B4A)
                    ]
                )
            ),
            child: Center(
                child: Wrap(
                    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                          number.toString(),
                          style: TextStyle(
                              color: AppDesign.current.textStyles.contrastColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          )
                      ),
                      Text(
                          name,
                          style: TextStyle(
                              color: AppDesign.current.textStyles.contrastColor,
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
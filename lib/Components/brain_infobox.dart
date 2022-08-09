import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';

class BrainInfobox extends StatelessWidget {
  final String title;
  final String shortDescription;
  final IconData icon;
  final bool isPrimary;

  const BrainInfobox({
    Key? key,
    required this.title,
    required this.shortDescription,
    required this.icon,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 210,
        minHeight: 150
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isPrimary ? AppDesign.current.primaryColor : AppDesign.current.boxStyle.backgroundColor,
        borderRadius: AppDesign.current.boxStyle.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isPrimary ? AppDesign.current.textStyles.contrastColor
                             : AppDesign.current.textStyles.color,
            size: 28
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 5),
            child: Text(
                shortDescription,
                style: TextStyle(
                    color: isPrimary ? AppDesign.current.textStyles.contrastColor.withOpacity(0.75)
                                     : AppDesign.current.textStyles.color.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.7
                )
            ),
          ),
          Text(
            title,
            style: isPrimary ? AppDesign.current.textStyles.collapsibleTextContrast
                             : AppDesign.current.textStyles.collapsibleText
          )
        ],
      ),
    );
  }
}
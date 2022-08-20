import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class BrainInfobox extends StatelessWidget {
  final String title;
  final String shortDescription;
  final IconData icon;
  final bool isPrimary;
  final Function()? action;

  BrainInfobox({
    Key? key,
    required this.title,
    required this.shortDescription,
    required this.icon,
    this.isPrimary = false,
    this.action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: title.length > 50 ? 50 + title.length * 2 : 210,
        maxHeight: 150,
        minHeight: 150
      ),
      decoration: BoxDecoration(
        borderRadius: AppDesign.current.boxStyle.borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        style: TextButton.styleFrom(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            backgroundColor: isPrimary ? AppDesign.current.primaryColor : AppDesign.current.boxStyle.backgroundColor
        ),
        onPressed: action,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                    icon,
                    color: isPrimary ? AppDesign.current.textStyles.contrastColor
                        : AppDesign.current.textStyles.color,
                    size: 28
                ),
                if (action != null) Icon(
                  Icons.chevron_right,
                  color: isPrimary ? AppDesign.current.textStyles.contrastColor
                      : AppDesign.current.textStyles.color,
                )
              ],
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
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: isPrimary ? AppDesign.current.textStyles.infoBoxTextContrast
                    : AppDesign.current.textStyles.infoBoxText
            )
          ]
        )
      )
    );
  }
}
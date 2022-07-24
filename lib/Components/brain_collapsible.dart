import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';

class BrainCollapsible extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? iconColor;
  final bool dark;
  final bool collapsed;
  final Function() onTap;

  const BrainCollapsible({
    Key? key,
    required this.text,
    required this.icon,
    required this.collapsed,
    required this.onTap,
    this.dark = false,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer (
          curve: Curves.easeOutBack,
          decoration: BoxDecoration(
              color: AppDesign.current.primaryColor,
              borderRadius: AppDesign.current.boxStyle.borderRadius
          ),
          padding: collapsed ? const EdgeInsets.all(8) : const EdgeInsets.all(17),
          duration: const Duration(milliseconds: 500),
          child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: AnimatedContainer(
                        curve: Curves.easeOutBack,
                        height: collapsed ? 25 : 35,
                        width: collapsed ? 25 : 35,
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 100),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                              icon,
                              color: iconColor == null || AppDesign.current.overrideIconColor ? AppDesign.current.textStyles.contrastColor : iconColor,
                              size: 35
                          ),
                        )
                    )
                ),
                if (!collapsed) Flexible(
                    child: Text(
                        text,
                        style: AppDesign.current.textStyles.collapsibleTextContrast
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}
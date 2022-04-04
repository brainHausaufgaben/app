import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollapsibleBox extends StatefulWidget {
  String text = "empty";
  IconData icon;
  Color? iconColor;
  bool collapsed;
  bool dark;

  CollapsibleBox({
    Key? key,
    required this.text,
    required this.icon,
    this.collapsed = false,
    this.dark = false,
    this.iconColor
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>  _CollapsibleBox();
}

class _CollapsibleBox extends State<CollapsibleBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.collapsed = !widget.collapsed;
        });
      },
      child: AnimatedContainer (
        decoration: BoxDecoration(
            color: widget.dark ? AppDesign.current.primaryColor : AppDesign.current.boxStyle.backgroundColor,
            borderRadius: AppDesign.current.boxStyle.borderRadius
        ),
        padding: widget.collapsed ? const EdgeInsets.all(8) : const EdgeInsets.all(17),
        duration: const Duration(milliseconds: 100),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AnimatedContainer(
                height: widget.collapsed ? 25 : 35,
                width: widget.collapsed ? 25 : 35,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 100),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                      widget.icon,
                      color: widget.iconColor == null || AppDesign.current.overrideIconColor ? (widget.dark ? AppDesign.current.textStyles.contrastColor : AppDesign.current.primaryColor) : widget.iconColor,
                      size: 35
                  ),
                )
              )
            ),
            if (!widget.collapsed) Flexible(
              child: Text(
                widget.text,
                style: widget.dark ? AppDesign.current.textStyles.collapsibleTextContrast : AppDesign.current.textStyles.collapsibleText
              )
            )
          ]
        ),
      ),
    );
  }
}
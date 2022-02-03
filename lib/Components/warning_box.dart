import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';


class WarningBox extends StatelessWidget {
  String text = "empty";
  List icons = ['../icons/redExclamationMark.png', '../icons/yellowExclamationMark.png', '../icons/greenCheckmark'];
  int iconIndex = 0;

  WarningBox({
    Key? key,
    required this.text,
    required this.iconIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: AppTheme.borderRadius
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12) ,
                  child: Image.asset(icons.elementAt(iconIndex), scale: 2),
                ),
                Flexible(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                )
              ]
          ),
        )
    );
  }
}
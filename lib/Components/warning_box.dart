import 'package:flutter/material.dart';
import '../utilities.dart';

class WarningBox extends StatelessWidget {
  String text = "empty";
  var icons = {'../icons/redExclamationMark.png', '../icons/yellowExclamationMark.png', '../icons/greenCheckmark'};
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
              color: AppTheme.mainColor,
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
                      style: TextStyle(color: AppTheme.mainTextColor, fontSize: 15),
                    )
                )
              ]
          ),
        )
    );
  }
}
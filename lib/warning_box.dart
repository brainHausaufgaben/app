import 'package:flutter/material.dart';
import 'utilities.dart';

class WarningBox extends StatelessWidget {
  const WarningBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.mainColor,
            borderRadius: AppTheme.borderRadius
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
            children: [
              Flexible(
                child: Text(
                  "Du hast noch unerledigte Hausaufgaben in 2 Fächern",
                  style: TextStyle(color: AppTheme.mainTextColor),
                )
              )
            ]
        ),
      )
    );
  }
}
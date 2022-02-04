import 'package:flutter/material.dart';
import '../utilities.dart';

class WarningBox extends StatelessWidget {
  String text = "empty";
  List icons = [const Icon(Icons.warning_rounded,color: Colors.red,size: 35,), const Icon(Icons.warning_rounded,color: Colors.orange,size: 35,), const Icon(Icons.check,color: Colors.green,size: 35,)];
  int iconIndex = 0;

  WarningBox({
    Key? key,
    required this.text,
    required this.iconIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 0),
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
                  child: icons[iconIndex],
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
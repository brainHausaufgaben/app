import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class EasterEggs {
  static void deadLine(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("..."),
            backgroundColor: AppDesign.current.boxStyle.backgroundColor,
            content: Center(
              child: Text("Work in Progress"),
            ),
          );
        }
    );
  }
}
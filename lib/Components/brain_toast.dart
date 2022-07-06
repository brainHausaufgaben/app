import 'package:flutter/material.dart';
import 'package:brain_app/main.dart';

class BrainToast {
  BrainToast({
    required this.text,
    this.action,
    this.buttonText
  });

  String text;
  String? buttonText;
  Function()? action;

  SnackBar build() {
    return SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: BrainApp.preferences["darkMode"] ? const Color(0xFFFFFFFF) : const Color(0xFF303540),
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: buttonText == null ? 15 : 10),
        content: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                        text,
                        style: TextStyle(
                            color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        )
                    )
                ),
              ),
              if (buttonText != null) TextButton(
                onPressed: action,
                style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: BorderSide(
                          color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF),
                          width: 1.5
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Text(
                        buttonText!,
                        style: TextStyle(
                            color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF))
                    ),
                  ),
              )
            ]
        )
    );
  }

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(build());
  }
}
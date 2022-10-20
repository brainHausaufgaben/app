import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class BrainToast {
  const BrainToast({
    required this.text,
    this.action,
    this.buttonText
  });

  final String text;
  final String? buttonText;
  final Function()? action;

  SnackBar build() {
    return SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: BrainApp.preferences["darkMode"] ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                  foregroundColor: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF),
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
                        fontSize: 13,
                        color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF)
                      )
                  ),
                ),
              )
            ]
        )
    );
  }

  void show() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if (MediaQuery.of(NavigationHelper.rootKey.currentContext!).size.width > AppDesign.breakPointWidth) {
        NavigationHelper.messengerKey.currentState!.showSnackBar(build());
      } else {
        ScaffoldMessenger.of(NavigationHelper.rootKey.currentContext!).showSnackBar(build());
      }
    });
  }

  static void close() {
    if (MediaQuery.of(NavigationHelper.rootKey.currentContext!).size.width > AppDesign.breakPointWidth) {
      NavigationHelper.messengerKey.currentState!.hideCurrentSnackBar();
    } else {
      ScaffoldMessenger.of(NavigationHelper.rootKey.currentContext!).hideCurrentSnackBar();
    }
  }
}
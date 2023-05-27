import 'dart:async';

import 'package:flutter/material.dart';

import '../Backend/design.dart';

class BrainConfirmationDialog extends StatelessWidget {
  const BrainConfirmationDialog({
    Key? key,
    required this.description,
    required this.onCancel,
    required this.onContinue,
    this.title = "Bist du dir sicher?",
    this.withCountdown = true
  }) : super(key: key);

  final String title;
  final String description;
  final Function() onCancel;
  final Function() onContinue;
  final bool withCountdown;

  @override
  Widget build(BuildContext context) {
    int countdown = withCountdown ? 3 : 0;

    return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        title: Text(
            title,
            style: AppDesign.textStyles.alertDialogHeader
        ),
        backgroundColor: AppDesign.colors.secondaryBackground,
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  description,
                  style: AppDesign.textStyles.alertDialogDescription,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppDesign.colors.primary,
                        foregroundColor: AppDesign.colors.contrast,
                        padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                    onPressed: onCancel,
                    child: Text(
                        "Abbrechen",
                        style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)
                    )
                ),
              ),
              StatefulBuilder(
                builder: (context, setBuilderState) {
                  if (countdown != 0) {
                    Timer(const Duration(seconds: 1), () => setBuilderState(() {
                      countdown--;
                    }));
                  }

                  return TextButton(
                      style: TextButton.styleFrom(
                          side: BorderSide(color: countdown == 0 ? AppDesign.colors.primary : AppDesign.colors.text05, width: 2),
                          foregroundColor: countdown == 0 ? AppDesign.colors.primary : AppDesign.colors.text05,
                          padding: const EdgeInsets.symmetric(vertical: 12)
                      ),
                      onPressed: countdown == 0 ? onContinue : null,
                      child: Text(
                          countdown == 0 ? "Fortfahren" : "Fortfahren in $countdown",
                          style: AppDesign.textStyles.buttonText.copyWith(
                              fontSize: 16,
                              color: countdown == 0 ? AppDesign.colors.primary : AppDesign.colors.text05
                          )
                      )
                  );
                }
              )
            ]
        )
    );
  }

}
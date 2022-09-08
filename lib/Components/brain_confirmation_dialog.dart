import 'package:flutter/material.dart';

import '../Backend/design.dart';

class BrainConfirmationDialog extends StatelessWidget {
  const BrainConfirmationDialog({
    Key? key,
    required this.description,
    required this.onCancel,
    required this.onContinue,
    this.title = "Bist du dir sicher?"
  }) : super(key: key);

  final String title;
  final String description;
  final Function() onCancel;
  final Function() onContinue;

  @override
  Widget build(BuildContext context) {
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
                        primary: AppDesign.colors.contrast,
                        padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                    onPressed: onCancel,
                    child: Text(
                        "Abbrechen",
                        style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)
                    )
                ),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      side: BorderSide(color: AppDesign.colors.primary, width: 2),
                      primary: AppDesign.colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12)
                  ),
                  onPressed: onContinue,
                  child: Text(
                      "Fortfahren",
                      style: AppDesign.textStyles.buttonText.copyWith(
                          fontSize: 16,
                          color: AppDesign.colors.primary
                      )
                  )
              )
            ]
        )
    );
  }

}
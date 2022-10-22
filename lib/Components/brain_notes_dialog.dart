import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

import '../Backend/design.dart';
import '../Backend/event.dart';
import '../Pages/Primary Pages/calendar.dart';
import '../main.dart';
import 'brain_inputs.dart';

class BrainNotesDialog extends StatelessWidget {
  BrainNotesDialog({
    super.key,
    this.note
  }) {
    controller.text = note?.description ?? "";
  }

  final Note? note;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.text.isEmpty ? "Neue Notiz" : "Notiz bearbeiten", style: AppDesign.textStyles.alertDialogHeader),
            if (note != null) BrainTitleButton(
              icon: Icons.delete_forever,
              semantics: "Notiz löschen",
              action: () {
                TimeTable.removeNote(note!);
                Navigator.of(context).pop();
                BrainApp.notifier.notifyOfChanges();
              }
            )
          ]
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Abbrechen")
          ),
          TextButton(
              onPressed: () {
                if (note == null) {
                  Note(CalendarPage.selectedDay, controller.text);
                } else {
                  note!.edit(note!.dueTime, note!.name, controller.text);
                }
                BrainApp.notifier.notifyOfChanges();
                Navigator.of(context).pop();
              },
              child: Text("Ok")
          )
        ],
        content: Container(
            constraints: const BoxConstraints(minWidth: 350, maxHeight: 500, maxWidth: 350),
            decoration: BoxDecoration(
                color: AppDesign.colors.background,
                borderRadius: AppDesign.boxStyle.inputBorderRadius
            ),
            padding: const EdgeInsets.all(11),
            child: BrainTextField(
              autofocus: true,
              maxLines: 10,
              placeholder: "Inhalt",
              controller: controller,
            )
        )
    );
  }
}
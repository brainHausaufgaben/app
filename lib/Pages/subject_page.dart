import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/brain_toast.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({Key? key, this.previousSubject}) : super(key: key) {
    subjectController.text = previousSubject != null ? previousSubject!.name : "";
    pickerColor = previousSubject != null ? previousSubject!.color : Colors.red;
  }

  Subject? previousSubject;
  final subjectController = TextEditingController();
  Color pickerColor = Colors.red;

  @override
  State<SubjectPage> createState() => _SubjectPage();
}

class _SubjectPage extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      backButton: true,
      title: widget.previousSubject != null ? "Fach Bearbeiten" : "Neues Fach",
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: BrainColorPicker(
                pickerColor: widget.pickerColor,
                onColorSelect: (color) {
                  setState(() {
                    widget.pickerColor = color;
                  });
                  Navigator.of(context, rootNavigator: true).pop();
                }
            )
          ),
          Flexible(
            child: BrainTextField(
              controller: widget.subjectController,
              placeholder: "Fach Name",
              maxLines: 1,
              maxLength: 20,
            )
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              children: [
                Expanded(
                  child: ElevatedButton (
                      onPressed: () {
                        if (widget.subjectController.text.isEmpty) {
                          BrainToast toast = BrainToast(text: "Du hast keinen Namen angegeben!");
                          toast.show(context);
                          return;
                        } else {
                          if (widget.previousSubject != null) {
                            TimeTable.getSubject(widget.previousSubject!.id)!.edit(widget.subjectController.text, widget.pickerColor);
                          } else {
                            Subject(widget.subjectController.text, widget.pickerColor);
                          }
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(widget.previousSubject == null ? "Hinzufügen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                      )
                  ),
                ),
                if (widget.previousSubject != null) Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton (
                        onPressed: () {
                          TimeTable.deleteSubject(widget.previousSubject!);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Icon(Icons.delete_forever, color: AppDesign.current.textStyles.contrastColor),
                        )
                    )
                )
              ]
          )
      )
    );
  }
}
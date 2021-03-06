import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/brain_toast.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({Key? key}) : super(key: key);

  Subject? previousSubject;
  final subjectController = TextEditingController();
  Color pickerColor = Colors.red;

  @override
  State<SubjectPage> createState() => _SubjectPage();
}

class _SubjectPage extends State<SubjectPage> {
  bool alreadyFetchedData = false;

  @override
  void dispose() {
    widget.subjectController.dispose();
    super.dispose();
  }

  void getData() {
    alreadyFetchedData = true;
    Subject? data = ModalRoute.of(context)!.settings.arguments as Subject?;
    if (data != null) {
      setState(() {
        widget.previousSubject = data;
        widget.subjectController.text = data.name;
        widget.pickerColor = data.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!alreadyFetchedData) getData();

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
                  Navigator.of(context).pop();
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
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(widget.previousSubject == null ? "Hinzuf??gen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                      )
                  ),
                ),
                if (widget.previousSubject != null) Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton (
                        onPressed: () {
                          TimeTable.deleteSubject(widget.previousSubject!);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.of(context).pop();
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
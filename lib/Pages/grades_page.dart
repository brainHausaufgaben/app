import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key? key, this.previousSubject}) : super(key: key) {
    subjectController.text = previousSubject != null ? previousSubject!.name : "";
    pickerColor = previousSubject != null ? previousSubject!.color : Colors.red;
  }

  Subject? previousSubject;
  final subjectController = TextEditingController();
  Color pickerColor = Colors.red;

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        backButton: true,
        title: widget.previousSubject != null ? "Note Bearbeiten" : "Neue Note",
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                  controller: widget.subjectController,
                  placeHolder: "Fach Name",
                  autocorrect: true,
                  maxLines: 1
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomColorPicker(
                      pickerColor: widget.pickerColor,
                      onColorSelect: (color) {
                        setState(() {
                          widget.pickerColor = color;
                        });
                        Navigator.pop(context);
                      }
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
                          if (widget.subjectController.text.isNotEmpty) {
                            if (widget.previousSubject != null) {
                              TimeTable.getSubject(widget.previousSubject!.id)!.edit(widget.subjectController.text, widget.pickerColor);
                              BrainApp.notifier.notifyOfChanges();
                            } else {
                              Subject(widget.subjectController.text, widget.pickerColor);
                            }
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
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Icon(Icons.delete_forever),
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}
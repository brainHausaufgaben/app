import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Backend/design.dart';
import '../Components/brain_toast.dart';
import '../Components/custom_inputs.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key? key, this.previousGrade, Subject? subject}) : super(key: key) {
    grade = previousGrade?.value ?? 0;
    selectedSubject = previousGrade?.subject ?? subject;
    type = previousGrade?.type;
  }

  Grade? previousGrade;
  int grade = 0;
  Subject? selectedSubject;
  GradeType? type;

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  void numberPickerDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppDesign.current.boxStyle.backgroundColor,
            title: Text("Wähle eine Note"),
            content: StatefulBuilder(
                builder: (context, setBuilderState) {
                  return NumberPicker(
                      selectedTextStyle: TextStyle(
                        color: AppDesign.current.primaryColor,
                        fontWeight: FontWeight.w700
                      ),
                      value: widget.grade,
                      minValue: 0,
                      maxValue: 15,
                      onChanged: (value) {
                        setBuilderState(() => widget.grade = value);
                      }
                  );
                }
            ),

            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      backButton: true,
      title: widget.previousGrade == null ? "Neue Note" : "Note Bearbeiten",
      child: Wrap(
          runSpacing: 10,
          children: [
            BrainIconButton(
              child: Text(widget.grade.toString(), style: AppDesign.current.textStyles.input),
              icon: Icons.numbers,
              action: numberPickerDialog
            ),
            BrainDropdown(
              defaultText: Text("Fach", style: AppDesign.current.textStyles.input),
              currentValue: widget.selectedSubject,
              items: BrainDropdown.getSubjectDropdowns(),
              onChanged: (subject) {
                setState(() => widget.selectedSubject = subject);
              },
            ),
            BrainDropdown(
              defaultText: Text("Art der Note", style: AppDesign.current.textStyles.input),
              currentValue: widget.type,
              items: [
                DropdownMenuItem(
                  value: GradeType.smallTest,
                  child: Text("Ex", style: AppDesign.current.textStyles.input)
                ),
                DropdownMenuItem(
                  value: GradeType.bigTest,
                  child: Text("Schulaufgabe", style: AppDesign.current.textStyles.input)
                ),
                DropdownMenuItem(
                  value: GradeType.oralGrade,
                  child: Text("Mündliche Note", style: AppDesign.current.textStyles.input)
                )
              ],
              onChanged: (newType) {
                setState(() => widget.type = newType);
              },
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
                      if (widget.selectedSubject == null) {
                        BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
                        toast.show(context);
                        return;
                      } else if (widget.type == null) {
                        BrainToast toast = BrainToast(text: "Du hast keine Art der Note angegeben!");
                        toast.show(context);
                        return;
                      } else {
                        if (widget.previousGrade == null) {
                          switch(widget.type) {
                          // TODO: man muss noch auswählen können welches halb/drittel jahr
                            case GradeType.bigTest:
                              BigGrade(widget.grade, widget.selectedSubject!, 1);
                              break;
                            case GradeType.smallTest:
                            case GradeType.oralGrade:
                              SmallGrade(widget.grade, widget.selectedSubject!, widget.type!, 1);
                              break;

                            default:
                              return;
                          }
                        } else {
                          widget.previousGrade!.edit(widget.grade, widget.selectedSubject, widget.type,null);
                        }
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.previousGrade == null ? "Hinzufügen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                    )
                ),
              ),
              if (widget.previousGrade != null) Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton (
                      onPressed: () {
                        GradingSystem.removeGrade(widget.previousGrade!);
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Icon(Icons.delete_forever, color: AppDesign.current.textStyles.contrastColor),
                      )
                  )
              )
            ],
          )
      ),
    );
  }
}
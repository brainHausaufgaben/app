import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key? key}) : super(key: key);

  Grade? previousGrade;
  int grade = 0;
  Subject? selectedSubject;
  GradeType? type;
  int semester = 0;

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  bool alreadyFetchedData = false;

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

  void getData() {
    alreadyFetchedData = true;
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) return;

    setState(() {
      switch(args.runtimeType) {
        case BigGrade:
        case SmallGrade:
        case Grade:
          widget.previousGrade = args;
          widget.grade = args.value;
          widget.selectedSubject = args.subject;
          widget.type = args.type;
          widget.semester = args.time.partOfYear;
          break;
        case Subject:
          widget.selectedSubject = args;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!alreadyFetchedData) getData();

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
              dialogTitle: "Wähle ein Fach",
              defaultText: "Fach",
              currentValue: widget.selectedSubject,
              items: BrainDropdown.getSubjectDropdowns(),
              onChanged: (subject) {
                setState(() => widget.selectedSubject = subject);
              },
            ),
            BrainDropdown(
              dialogTitle: "Wähle eine Notenart",
              scrollableDialog: false,
              defaultText: "Art der Note",
              currentValue: widget.type,
              items: [
                BrainDropdownEntry(
                  value: GradeType.smallTest,
                  child: Text("Ex", style: AppDesign.current.textStyles.input)
                ),
                BrainDropdownEntry(
                  value: GradeType.bigTest,
                  child: Text("Schulaufgabe", style: AppDesign.current.textStyles.input)
                ),
                BrainDropdownEntry(
                  value: GradeType.oralGrade,
                  child: Text("Mündliche Note", style: AppDesign.current.textStyles.input)
                )
              ],
              onChanged: (newType) {
                setState(() => widget.type = newType);
              },
            ),
            BrainDropdown(
              dialogTitle: "Semester des Jahres",
              scrollableDialog: false,
              defaultText: "Semester des Jahres",
              currentValue: widget.semester,
              items: [
                BrainDropdownEntry(
                    value: 1,
                    child: Text("1. Semester", style: AppDesign.current.textStyles.input)
                ),
                BrainDropdownEntry(
                    value: 2,
                    child: Text("2. Semester", style: AppDesign.current.textStyles.input)
                ),
                BrainDropdownEntry(
                    value: 3,
                    child: Text("3. Semester", style: AppDesign.current.textStyles.input)
                ),
              ],
              onChanged: (newSemester) {
                setState(() => widget.semester = newSemester);
              },
            )
          ]
      ),
      pageSettings: const PageSettings(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
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
                            case GradeType.bigTest:
                              BigGrade(widget.grade, widget.selectedSubject!, widget.semester);
                              break;
                            case GradeType.smallTest:
                            case GradeType.oralGrade:
                              SmallGrade(widget.grade, widget.selectedSubject!, widget.type!, widget.semester);
                              break;
                            default:
                              return;
                          }
                        } else {
                          widget.previousGrade!.edit(widget.grade, widget.selectedSubject, widget.type, GradeTime(GradingSystem.currentYear, widget.semester));
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
                        Navigator.of(context).pop();
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
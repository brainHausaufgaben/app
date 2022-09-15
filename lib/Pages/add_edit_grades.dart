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
  int grade = GradingSystem.isAdvancedLevel ? 0 : 1;
  Subject? selectedSubject;
  GradeType? type;
  int? semester;
  TextEditingController nameController = TextEditingController();

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  void numberPickerDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppDesign.colors.secondaryBackground,
            title: Text(
              "Wähle eine Note",
              style: AppDesign.textStyles.alertDialogHeader,
            ),
            content: StatefulBuilder(
                builder: (context, setBuilderState) {
                  return NumberPicker(
                      selectedTextStyle: TextStyle(
                        color: AppDesign.colors.primary,
                        fontWeight: FontWeight.w700
                      ),
                      value: widget.grade,
                      minValue: GradingSystem.isAdvancedLevel ? 0 : 1,
                      maxValue: GradingSystem.isAdvancedLevel ? 15 : 6,
                      onChanged: (value) {
                        setBuilderState(() => widget.grade = value);
                      }
                  );
                }
            ),

            actions: [
              TextButton(
                child: Text("Ok", style: TextStyle(color: AppDesign.colors.primary)),
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
  void initState() {
    widget.semester = BrainApp.preferences["currentSemester"] == 0
        ? null
        : BrainApp.preferences["currentSemester"];
    super.initState();
  }

  void getData() {
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
          widget.nameController.text = args.name;
          break;
        case Subject:
          widget.selectedSubject = args;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedSubject == null) getData();
    return PageTemplate(
      backButton: true,
      title: widget.previousGrade == null ? "Neue Note" : "Note Bearbeiten",
      pageSettings: const PageSettings(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton (
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppDesign.colors.primary
                    ),
                    onPressed: () {
                      if (widget.selectedSubject == null) {
                        BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
                        toast.show();
                        return;
                      } else if (widget.type == null) {
                        BrainToast toast = BrainToast(text: "Du hast keine Art der Note angegeben!");
                        toast.show();
                        return;
                      } else if (widget.semester == null) {
                        BrainToast toast = BrainToast(text: "Du hast kein Semester angegeben!");
                        toast.show();
                        return;
                      } else {
                        if(widget.nameController.text == ""){
                          switch(widget.type){
                            case GradeType.bigTest:
                              widget.nameController.text = "Schulaufgabe";
                              break;
                            case GradeType.smallTest:
                              widget.nameController.text = "Ex";
                              break;
                            case GradeType.oralGrade:
                              widget.nameController.text = "Mündliche Note";
                              break;
                            default:
                              widget.nameController.text = "Note";
                          }
                        }
                        BrainApp.updatePreference("currentSemester", widget.semester);
                        if (widget.previousGrade == null) {
                          switch(widget.type) {
                            case GradeType.bigTest:
                              BigGrade(widget.grade, widget.selectedSubject!,widget.nameController.text, widget.semester!);
                              break;
                            case GradeType.smallTest:
                            case GradeType.oralGrade:
                              SmallGrade(widget.grade, widget.selectedSubject!, widget.type!,widget.nameController.text, widget.semester!);
                              break;
                            default:
                              return;
                          }
                        } else {
                          widget.previousGrade!.edit(widget.grade, widget.selectedSubject, widget.type, GradeTime(GradingSystem.currentYear, widget.semester!),widget.nameController.text);
                        }
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.previousGrade == null ? "Hinzufügen" : "Bearbeiten",
                        style: AppDesign.textStyles.buttonText
                      ),
                    )
                ),
              ),
              if (widget.previousGrade != null) Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton (
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppDesign.colors.primary
                      ),
                      onPressed: () {
                        GradingSystem.removeGrade(widget.previousGrade!);
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Icon(Icons.delete_forever, color: AppDesign.colors.contrast),
                      )
                  )
              )
            ],
          )
      ),
      child: Wrap(
          runSpacing: 10,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: BrainTextField(
                    placeholder: "Noten Name",
                    controller: widget.nameController,
                    maxLines: 1,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  constraints: const BoxConstraints(
                    maxWidth: 100
                  ),
                  child: BrainIconButton(
                      icon: Icons.numbers,
                      action: numberPickerDialog,
                      child: Text(
                          widget.grade.toString(),
                          style: AppDesign.textStyles.input
                      )
                  )
                )
              ]
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
            BrainDropdown.fromMap(
              dialogTitle: "Wähle eine Notenart",
              defaultText: "Art der Note",
              currentValue: widget.type,
              entries: {
                GradeType.smallTest : Text(
                    "Ex",
                    style: AppDesign.textStyles.input
                ),
                GradeType.bigTest : Text(
                    "Schulaufgabe",
                    style: AppDesign.textStyles.input
                ),
                GradeType.oralGrade : Text(
                    "Mündliche Note",
                    style: AppDesign.textStyles.input
                )
              },
              onChanged: (newType) {
                setState(() => widget.type = newType);
              },
            ),
            BrainDropdown.fromMap(
              dialogTitle: "Semester des Jahres",
              defaultText: "Semester des Jahres",
              currentValue: widget.semester,
              entries: {
                1 : Text(
                    "1. Semester",
                    style: AppDesign.textStyles.input
                ),
                2 : Text(
                    "2. Semester",
                    style: AppDesign.textStyles.input
                ),
                if (!GradingSystem.isAdvancedLevel) 3 : Text(
                    "3. Semester",
                    style: AppDesign.textStyles.input
                )
              },
              onChanged: (newSemester) {
                setState(() {
                  widget.semester = newSemester;
                  BrainApp.preferences["currentSemester"] = newSemester;
                });
              }
            )
          ]
      )
    );
  }
}
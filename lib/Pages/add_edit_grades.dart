import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Components/animated_delete_button.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  Grade? previousGrade;
  int grade = GradingSystem.isAdvancedLevel ? 0 : 1;
  Subject? selectedSubject;
  GradeType? type;
  int? semester;
  TextEditingController nameController = TextEditingController();
  
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
                      value: grade,
                      minValue: GradingSystem.isAdvancedLevel ? 0 : 1,
                      maxValue: GradingSystem.isAdvancedLevel ? 15 : 6,
                      onChanged: (value) {
                        setBuilderState(() => grade = value);
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
    semester = BrainApp.preferences["currentSemester"] == 0
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
          previousGrade = args;
          grade = args.value;
          selectedSubject = args.subject;
          type = args.type;
          semester = args.time.partOfYear;
          nameController.text = args.name;
          break;
        case Subject:
          selectedSubject = args;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSubject == null) getData();
    return PageTemplate(
      secondaryPage: true,
      title: previousGrade == null ? "Neue Note" : "Note Bearbeiten",
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
                      if (selectedSubject == null) {
                        BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
                        toast.show();
                        BrainVibrations.errorVibrate();
                        return;
                      } else if (type == null) {
                        BrainToast toast = BrainToast(text: "Du hast keine Art der Note angegeben!");
                        toast.show();
                        BrainVibrations.errorVibrate();
                        return;
                      } else if (semester == null) {
                        BrainToast toast = BrainToast(text: "Du hast kein Teiljahr angegeben!");
                        toast.show();
                        BrainVibrations.errorVibrate();
                        return;
                      } else {
                        if(nameController.text == ""){
                          switch(type){
                            case GradeType.bigTest:
                              nameController.text = "Schulaufgabe";
                              break;
                            case GradeType.smallTest:
                              nameController.text = "Ex";
                              break;
                            case GradeType.oralGrade:
                              nameController.text = "Mündliche Note";
                              break;
                            default:
                              nameController.text = "Note";
                          }
                        }
                        BrainApp.updatePreference("currentSemester", semester);
                        if (previousGrade == null) {
                          switch(type) {
                            case GradeType.bigTest:
                              BigGrade(grade, selectedSubject!,nameController.text, semester!);
                              break;
                            case GradeType.smallTest:
                            case GradeType.oralGrade:
                              SmallGrade(grade, selectedSubject!, type!,nameController.text, semester!);
                              break;
                            default:
                              return;
                          }
                        } else {
                          previousGrade!.edit(grade, selectedSubject, type, GradeTime(GradingSystem.currentYear, semester!),nameController.text);
                        }
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        previousGrade == null ? "Hinzufügen" : "Bearbeiten",
                        style: AppDesign.textStyles.buttonText
                      )
                    )
                )
              ),
              if (previousGrade != null) Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AnimatedDeleteButton(
                    onDelete: () {
                      GradingSystem.removeGrade(previousGrade!);
                      BrainApp.notifier.notifyOfChanges();
                      Navigator.of(context).pop();
                    }
                  )
              )
            ]
          )
      ),
      body: Wrap(
          runSpacing: 10,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: BrainTextField(
                    placeholder: "Noten Name",
                    controller: nameController,
                    maxLines: 1,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  constraints: const BoxConstraints(
                    maxWidth: 100
                  ),
                  child: BrainButton(
                      icon: Icons.numbers,
                      action: numberPickerDialog,
                      child: Text(
                          grade.toString(),
                          style: AppDesign.textStyles.input
                      )
                  )
                )
              ]
            ),
            BrainDropdown(
              dialogTitle: "Wähle ein Fach",
              defaultText: "Fach",
              currentValue: selectedSubject,
              items: BrainDropdown.getSubjectDropdowns(),
              onChanged: (subject) {
                setState(() => selectedSubject = subject);
              }
            ),
            BrainDropdown.fromMap(
              dialogTitle: "Wähle eine Notenart",
              defaultText: "Art der Note",
              currentValue: type,
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
                setState(() => type = newType);
              },
            ),
            BrainDropdown.fromMap(
              dialogTitle: "Teiljahr",
              defaultText: "Teiljahr",
              currentValue: semester,
              entries: {
                1 : Text(
                    "1. Teiljahr",
                    style: AppDesign.textStyles.input
                ),
                2 : Text(
                    "2. Teiljahr",
                    style: AppDesign.textStyles.input
                ),
                if (!GradingSystem.isAdvancedLevel) 3 : Text(
                    "3. Teiljahr",
                    style: AppDesign.textStyles.input
                )
              },
              onChanged: (newSemester) {
                setState(() {
                  semester = newSemester;
                  BrainApp.preferences["currentSemester"] = newSemester;
                });
              }
            )
          ]
      )
    );
  }
}
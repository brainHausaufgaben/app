import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key, this.previousTest}) : super(key: key) {
    descriptionController.text = previousTest?.description ?? "";
    selectedDate = previousTest?.dueTime ?? DateTime.now();
    selectedSubject = previousTest?.subject;
  }

  Test? previousTest;
  final descriptionController = TextEditingController();
  Subject? selectedSubject;
  late DateTime selectedDate;

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  List<DropdownMenuItem<Subject>> getDropdowns() {
    List<DropdownMenuItem<Subject>> subjects = [];
    for (Subject subject in TimeTable.subjects) {
      subjects.add(
          DropdownMenuItem<Subject>(
            alignment: Alignment.bottomCenter,
            child: PointElement(
                primaryText: subject.name,
                color: subject.color),
            value: subject,
          )
      );
    }
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      backButton: true,
      title: widget.previousTest != null ? "Test Bearbeiten" : "Neuer Test",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              runSpacing: 10,
              children: [
                CustomTextField(
                  controller: widget.descriptionController,
                  placeHolder: "Test Inhalte",
                  autocorrect: true,
                  maxLines: 10,
                ),
                CustomDropdown(
                    defaultText: Text(
                        "Fach", style: AppDesign.current.textStyles.input),
                    items: getDropdowns(),
                    currentValue: widget.selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        widget.selectedSubject = newValue;
                      });
                    }
                ),
                CustomDateButton(
                    value: widget.selectedDate,
                    text: "Nächste Stunde",
                    onDateSelect: (value) {
                      setState(() {
                        widget.selectedDate = value;
                      });
                    },
                    customDateBuilder: (date, style) {
                      if (date.day >= DateTime
                          .now()
                          .day || date.month > DateTime
                          .now()
                          .month) {
                        if (TimeTable.getSubjectsByDate(date).contains(
                            widget.selectedSubject)) {
                          return Container(
                              decoration: BoxDecoration(
                                color: widget.selectedSubject!.color
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: style,
                                  )
                              )
                          );
                        }
                      }
                    }
                )
              ],
            ),
          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.descriptionController.text.isNotEmpty &&
                            widget.selectedSubject != null) {
                          Test(widget.selectedSubject!, widget.selectedDate,
                              widget.descriptionController.text);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text("Hinzufügen",
                            style: AppDesign.current.textStyles.buttonText),
                      )
                  ),
                ),
                if (widget.previousTest != null) Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          TimeTable.removeTest(widget.previousTest!);
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
      ),
    );
  }
}

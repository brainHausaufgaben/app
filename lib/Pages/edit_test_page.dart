import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Components/test_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class EditTestPage extends StatefulWidget {
  EditTestPage({Key? key, this.previousTest}) : super(key: key) {
    testSubpage = TestSubpage(previousTest: previousTest);
  }

  Test? previousTest;
  TestSubpage testSubpage = TestSubpage();

  @override
  State<EditTestPage> createState() => _EditTestPage();
}

class _EditTestPage extends State<EditTestPage> {
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
      child: widget.testSubpage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        String description = widget.testSubpage.descriptionController.text;
                        Subject? subject = widget.testSubpage.selectedSubject;
                        DateTime date = widget.testSubpage.selectedDate;

                        if (description.isNotEmpty && subject != null) {
                          widget.previousTest!.edit(subject, date, description);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text("Bearbeiten",
                            style: AppDesign.current.textStyles.buttonText),
                      )
                  ),
                ),
                Padding(
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
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/test_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class EditTestPage extends StatefulWidget {
  EditTestPage({Key? key}) : super(key: key);

  Test? previousTest;
  TestSubpage testSubpage = TestSubpage();

  @override
  State<EditTestPage> createState() => _EditTestPage();
}

class _EditTestPage extends State<EditTestPage> {
  void getData() {
    Test data = ModalRoute.of(context)!.settings.arguments as Test;
    setState(() {
      widget.previousTest = data;
      widget.testSubpage = TestSubpage(previousTest: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.previousTest == null) getData();

    return PageTemplate(
      backButton: true,
      title: "Test Bearbeiten",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
                runSpacing: 10,
                children: [
                  BrainTextField(
                    controller: widget.testSubpage.descriptionController,
                    placeholder: "Test Inhalte",
                    maxLines: 10,
                  ),
                  BrainDropdown(
                    dialogTitle: "Wähle ein Fach",
                    defaultText: "Fach",
                    items: BrainDropdown.getSubjectDropdowns(),
                    currentValue: widget.testSubpage.selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        widget.testSubpage.selectedSubject = newValue;
                      });
                    }
                  ),
                  BrainDateButton(
                      value: widget.testSubpage.selectedDate,
                      text: "Nächste Stunde",
                      selectedSubject: widget.testSubpage.selectedSubject,
                      onDateSelect: (value) {
                        setState(() {
                          widget.testSubpage.selectedDate = value;
                        });
                      }
                  )
                ]
            )
          ]
      ),
      pageSettings: const PageSettings(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      ),
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

                        if (description.isEmpty) {
                          BrainToast toast = BrainToast(text: "Du hast keine Inhalte angegeben!");
                          toast.show();
                          return;
                        } else if (subject == null) {
                          BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
                          toast.show();
                          return;
                        } else {
                          widget.previousTest!.edit(subject, date, description);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(""
                          "Bearbeiten",
                          style: AppDesign.textStyles.buttonText
                        )
                      )
                  )
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          TimeTable.removeTest(widget.previousTest!);
                          BrainApp.notifier.notifyOfChanges();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Icon(Icons.delete_forever, color: AppDesign.colors.contrast),
                        )
                    )
                )
              ]
          )
      ),
    );
  }
}

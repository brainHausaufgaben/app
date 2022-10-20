import 'package:brain_app/Backend/brain_vibrations.dart';
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

import '../Components/animated_delete_button.dart';

class EditTestPage extends StatefulWidget {
  const EditTestPage({Key? key}) : super(key: key);

  @override
  State<EditTestPage> createState() => _EditTestPage();
}

class _EditTestPage extends State<EditTestPage> {
  Test? previousTest;
  TestSubpage testSubpage = TestSubpage();
  
  void getData() {
    Test data = ModalRoute.of(context)!.settings.arguments as Test;
    setState(() {
      previousTest = data;
      testSubpage = TestSubpage(previousTest: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (previousTest == null) getData();

    return PageTemplate(
      secondaryPage: true,
      title: "Test Bearbeiten",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
                runSpacing: 10,
                children: [
                  BrainTextField(
                    controller: testSubpage.descriptionController,
                    placeholder: "Test Inhalte",
                    maxLines: 10,
                  ),
                  BrainDropdown(
                    dialogTitle: "Wähle ein Fach",
                    defaultText: "Fach",
                    items: BrainDropdown.getSubjectDropdowns(),
                    currentValue: testSubpage.selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        testSubpage.selectedSubject = newValue;
                      });
                    }
                  ),
                  BrainDateButton(
                      value: testSubpage.selectedDate,
                      text: "Nächste Stunde",
                      selectedSubject: testSubpage.selectedSubject,
                      onDateSelect: (value) {
                        setState(() {
                          testSubpage.selectedDate = value;
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
                        String description = testSubpage.descriptionController.text;
                        Subject? subject = testSubpage.selectedSubject;
                        DateTime date = testSubpage.selectedDate;

                        if (description.isEmpty) {
                          BrainToast toast = BrainToast(text: "Du hast keine Inhalte angegeben!");
                          toast.show();
                          BrainVibrations.errorVibrate();
                          return;
                        } else if (subject == null) {
                          BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
                          toast.show();
                          BrainVibrations.errorVibrate();
                          return;
                        } else {
                          previousTest!.edit(subject, date, description);
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
                    child: AnimatedDeleteButton(
                      onDelete: () {
                        TimeTable.removeTest(previousTest!);
                        BrainApp.notifier.notifyOfChanges();
                        Navigator.pop(context);
                      }
                    )
                )
              ]
          )
      ),
    );
  }
}

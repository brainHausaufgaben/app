import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/calendar_page.dart';
import 'package:flutter/material.dart';

class TestSubpage extends StatefulWidget {
  TestSubpage({Key? key, this.previousTest}) : super(key: key) {
    descriptionController.text = previousTest?.description ?? "";
    selectedSubject = previousTest?.subject;
    selectedDate = previousTest?.dueTime ?? CalendarPage.selectedDay;
  }

  Test? previousTest;
  Subject? selectedSubject;
  final descriptionController = TextEditingController();
  late DateTime selectedDate;

  @override
  State<TestSubpage> createState() => _TestSubpage();
}

class _TestSubpage extends State<TestSubpage> {
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
    return Column(
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
                    selectedSubject: widget.selectedSubject,
                    onDateSelect: (value) {
                      setState(() {
                        widget.selectedDate = value;
                      });
                    }
                )
              ]
          )
        ]
    );
  }
}
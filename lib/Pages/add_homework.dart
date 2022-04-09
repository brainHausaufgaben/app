import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);
  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {
  final homeworkController = TextEditingController();
  Subject? selectedSubject;
  DateTime selectedDate = DateTime(10);

  List<DropdownMenuItem<Subject>> getDropdowns(){
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
        DropdownMenuItem<Subject>(
          alignment: Alignment.bottomCenter,
          child: PointElement(primaryText: subject.name, color: subject.color),
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
        title: "Neue Hausaufgabe",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextField(
                controller: homeworkController,
                placeHolder: "Hausaufgabe",
                autocorrect: true
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomDropdown(
                    defaultText: Text("Fach", style: AppDesign.current.textStyles.input),
                    items: getDropdowns(),
                    currentValue: selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubject = newValue;
                      });
                    }
                )
            ),
            CustomDateButton(
                value: selectedDate,
                text: "Nächste Stunde",
                onDateSelect: (value) {
                  setState((){
                    selectedDate = value;
                  });
                }
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton (
                  onPressed: (){
                    if(homeworkController.text.isNotEmpty && selectedSubject != null){
                      if(selectedDate.year != 10) {
                        TimeInterval? time = selectedSubject?.getTime(
                            TimeTable.getDayFromDate(selectedDate));
                        if (time == null) return;
                        DateTime date = DateTime(
                            selectedDate.year, selectedDate.month,
                            selectedDate.day, time.startTime.hour,
                            time.startTime.minute);
                        Homework(selectedSubject!, date,
                            homeworkController.text);
                      }
                      else {
                        Homework(selectedSubject!,selectedSubject!
                            .getNextDate()! ,homeworkController.text);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text("Hinzufügen", style: AppDesign.current.textStyles.buttonText),
                  )
              ),
            )
          ],
        )
    );
  }
}
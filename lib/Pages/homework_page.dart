import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  HomeworkPage({Key? key, this.previousHomework}) : super(key: key) {
    homeworkController.text = previousHomework != null ? previousHomework!.name : "";
    selectedSubject = previousHomework != null ? previousHomework!.subject : null;
    selectedDate = previousHomework != null ? previousHomework!.dueTime : DateTime(10);
  }

  Homework? previousHomework;
  final homeworkController = TextEditingController();
  Subject? selectedSubject;
  late DateTime selectedDate;

  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {

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

  void onPressed() {
    if(widget.homeworkController.text.isNotEmpty && widget.selectedSubject != null){
      if (widget.previousHomework != null) {
        widget.previousHomework?.edit(widget.selectedSubject, widget.selectedDate, widget.homeworkController.text);
        TimeTable.app!.setState(() {});
      } else if(widget.selectedDate.year != 10) {
        TimeInterval? time = widget.selectedSubject?.getTime(TimeTable.getDayFromDate(widget.selectedDate));
        // TODO: Man soll das trotzdem rein machen können. muss dann halt im Kalendar sein
        if (time == null) return;
        DateTime date = DateTime(
            widget.selectedDate.year, widget.selectedDate.month,
            widget.selectedDate.day, time.startTime.hour,
            time.startTime.minute);

        Homework(widget.selectedSubject!, date, widget.homeworkController.text);
      } else {
        Homework(widget.selectedSubject!,widget.selectedSubject!.getNextDate()! ,widget.homeworkController.text);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        backButton: true,
        title: widget.previousHomework == null ? "Neue Hausaufgabe" : "Hausaufgabe Bearbeiten",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextField(
                controller: widget.homeworkController,
                placeHolder: "Hausaufgabe",
                autocorrect: true
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomDropdown(
                    defaultText: Text("Fach", style: AppDesign.current.textStyles.input),
                    items: getDropdowns(),
                    currentValue: widget.selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        widget.selectedSubject = newValue;
                      });
                    }
                )
            ),
            CustomDateButton(
                value: widget.selectedDate,
                text: "Nächste Stunde",
                onDateSelect: (value) {
                  setState((){
                     widget.selectedDate = value;
                  });
                },
                customDateBuilder: (date, style) {
                  if (TimeTable.getSubjectsByDate(date).contains(widget.selectedSubject)) {
                    return Container(
                      decoration: BoxDecoration(
                        color: widget.selectedSubject!.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: style,
                        ),
                      ),
                    );
                  }
                },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton (
                  onPressed: () {onPressed();},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(widget.previousHomework == null ? "Hinzufügen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                  )
              ),
            )
          ],
        )
    );
  }
}
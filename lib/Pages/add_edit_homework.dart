import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  HomeworkPage({Key? key}) : super(key: key);

  Homework? previousHomework;
  TextEditingController homeworkController = TextEditingController();
  Subject? selectedSubject;
  DateTime selectedDate = DateTime(10);

  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {
  bool alreadyFetchedData = false;

  void onPressed() {
    if (widget.homeworkController.text.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keine Hausaufgabe angegeben!");
      toast.show(context);
      return;
    } else if (widget.selectedSubject == null) {
      BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
      toast.show(context);
      return;
    } else {
      if (widget.previousHomework != null) {
        widget.previousHomework?.edit(widget.selectedSubject, widget.selectedDate, widget.homeworkController.text);
        BrainApp.notifier.notifyOfChanges();
      } else if(widget.selectedDate.year != 10) {
        TimeInterval? time = widget.selectedSubject?.getTime(TimeTable.getDayFromDate(widget.selectedDate));
        // TODO: Man soll das trotzdem rein machen können. muss dann halt im Kalendar sein
        if (time == null) {
          BrainToast toast = BrainToast(text: "An diesem Tag hast du das ausgewählte Fach nicht!");
          toast.show(context);
          return;
        };
        DateTime date = DateTime(
            widget.selectedDate.year, widget.selectedDate.month,
            widget.selectedDate.day, time.startTime.hour,
            time.startTime.minute);

        Homework(widget.selectedSubject!, date, widget.homeworkController.text);
      } else {
        Homework(widget.selectedSubject!,widget.selectedSubject!.getNextDate()! ,widget.homeworkController.text);
      }
      Navigator.of(context).pop();
    }
  }

  void getData() {
    alreadyFetchedData = true;
    Homework? data = ModalRoute.of(context)!.settings.arguments as Homework?;
    if (data != null) {
      setState(() {
        widget.previousHomework = data;
        widget.homeworkController.text = data.name;
        widget.selectedSubject = data.subject;
        widget.selectedDate = data.dueTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!alreadyFetchedData) getData();

    return PageTemplate(
      backButton: true,
      title: widget.previousHomework == null ? "Neue Hausaufgabe" : "Hausaufgabe Bearbeiten",
      child: Wrap(
        runSpacing: 10,
        children: [
          BrainTextField(
            controller: widget.homeworkController,
            placeholder: "Hausaufgabe",
          ),
          BrainDropdown(
              defaultText: Text("Fach", style: AppDesign.current.textStyles.input),
              items: BrainDropdown.getSubjectDropdowns(),
              currentValue: widget.selectedSubject,
              onChanged: (newValue) {
                setState(() {
                  widget.selectedSubject = newValue;
                });
              }
          ),
          BrainDateButton(
            value: widget.selectedDate,
            text: "Nächste Stunde",
            selectedSubject: widget.selectedSubject,
            onDateSelect: (value) {
              setState((){
                 widget.selectedDate = value;
              });
            }
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton (
                    onPressed: () {
                      onPressed();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.previousHomework == null ? "Hinzufügen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                    )
                ),
              )
            ],
          )
      ),
    );
  }
}
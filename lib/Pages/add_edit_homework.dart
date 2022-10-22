import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {
  TextEditingController homeworkController = TextEditingController();
  Homework? previousHomework;
  Subject? selectedSubject;
  DateTime selectedDate = DateTime(10);

  @override
  void dispose() {
    homeworkController.dispose();
    super.dispose();
  }

  void onPressed() {
    if (homeworkController.text.isEmpty) {
      BrainToast toast = const BrainToast(text: "Du hast keine Hausaufgabe angegeben!");
      BrainVibrations.errorVibrate();
      toast.show();
      return;
    } else if (selectedSubject == null) {
      BrainToast toast = const BrainToast(text: "Du hast kein Fach angegeben!");
      BrainVibrations.errorVibrate();
      toast.show();
      return;
    } else {
      if (previousHomework != null) {
        previousHomework?.edit(selectedSubject, selectedDate, homeworkController.text);
        BrainApp.notifier.notifyOfChanges();
      } else if(selectedDate.year != 10) {
        TimeInterval? time = selectedSubject?.getTime(TimeTable.getDayFromDate(selectedDate));

        DateTime date = DateTime(
            selectedDate.year, selectedDate.month,
            selectedDate.day, time?.startTime.hour ?? 0,
            time?.startTime.minute ?? 0
        );

        Homework(selectedSubject!, date, homeworkController.text);
      } else {
        DateTime? time = selectedSubject!.getNextDate();
        if (time == null) {
          BrainToast toast = const BrainToast(text: "Es gibt keine nächste Stunde, da dieses Fach nicht in deinem Stundenplan vorkommt!");
          toast.show();
          BrainVibrations.errorVibrate();
          return;
        } else if(time.year == DateTime.now().year && time.month == DateTime.now().month && time.day == DateTime.now().day){
            time = time.add(const Duration(days: 7));
        }
        Homework(selectedSubject!,time,homeworkController.text);
      }
      Navigator.of(context).pop();
    }
  }

  void getData() {
    Homework? data = ModalRoute.of(context)!.settings.arguments as Homework?;
    if (data != null) {
      setState(() {
        previousHomework = data;
        homeworkController.text = data.name;
        selectedSubject = data.subject;
        selectedDate = data.dueTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (previousHomework == null) getData();

    return PageTemplate(
      secondaryPage: true,
      title: previousHomework == null ? "Neue Hausaufgabe" : "Hausaufgabe Bearbeiten",
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
                onPressed: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                      previousHomework == null ? "Hinzufügen" : "Bearbeiten",
                    style: AppDesign.textStyles.buttonText
                  )
                )
              )
            )
          ]
        )
      ),
      body: Wrap(
        runSpacing: 10,
        children: [
          BrainTextField(
            autofocus: true,
            controller: homeworkController,
            placeholder: "Hausaufgabe",
          ),
          BrainDropdown(
            dialogTitle: "Wähle ein Fach",
            defaultText: "Fach",
            items: BrainDropdown.getSubjectDropdowns(),
            currentValue: selectedSubject,
            onChanged: (newValue) {
              setState(() {
                selectedSubject = newValue;
              });
            }
          ),
          BrainDateButton(
            value: selectedDate,
            text: "Nächste Stunde",
            selectedSubject: selectedSubject,
            todayAsDefault: selectedDate.year == 10,
            onDateSelect: (value) {
              setState((){
                selectedDate = value;
              });
            }
          )
        ]
      )
    );
  }
}
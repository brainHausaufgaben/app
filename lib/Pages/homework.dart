import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
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

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String weekDay =  weekDays[date.weekday - 1];
    return weekDay + ", " + day + "." + month + "." + year;
  }

  List<DropdownMenuItem<Subject>> getDropdowns(){
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
        subjects.add(
          DropdownMenuItem<Subject>(
            child: Text(subject.name),
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                maxLines: null,
                autocorrect: true,
                controller: homeworkController,
                style: AppDesign.current.textStyles.input,
                decoration: InputDecoration (
                  filled: true,
                  fillColor: AppDesign.current.boxStyle.backgroundColor,
                  label: Text("Hausaufgabe", style: AppDesign.current.textStyles.input),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
                        color: AppDesign.current.boxStyle.backgroundColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: DropdownButton<Subject>(
                        underline: Container(),
                        isExpanded: true,
                        dropdownColor: AppDesign.current.boxStyle.backgroundColor,
                        style: AppDesign.current.textStyles.input,
                        value: selectedSubject,
                        hint: Text("Fach", style: AppDesign.current.textStyles.input),
                        items: getDropdowns(),
                        onChanged: (Subject? newValue) {
                          setState(() {
                            selectedSubject = newValue!;
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    )
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  backgroundColor: AppDesign.current.boxStyle.backgroundColor
                ),
                onPressed: () {
                  Future<DateTime?> newDateTime = showRoundedDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 1),
                    borderRadius: 16,
                    theme: AppDesign.current.themeData,
                    height: 300,
                    styleDatePicker: MaterialRoundedDatePickerStyle(
                      paddingMonthHeader: const EdgeInsets.all(11),
                      backgroundPicker: AppDesign.current.boxStyle.backgroundColor,
                      textStyleDayOnCalendar: TextStyle(color: AppDesign.current.textStyles.color),
                      textStyleMonthYearHeader: TextStyle(color: AppDesign.current.textStyles.color),
                      textStyleDayHeader: TextStyle(color: AppDesign.current.textStyles.color),
                      colorArrowNext: AppDesign.current.textStyles.color,
                      colorArrowPrevious: AppDesign.current.textStyles.color,
                    )
                  );
                  newDateTime.then((value) => setState((){selectedDate = value!;}));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate.year == 10 ? "Nächste Stunde" : getDateString(selectedDate), style: AppDesign.current.textStyles.input),
                    const Icon(Icons.date_range),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton (
                    onPressed: (){
                      if(homeworkController.text.isNotEmpty && selectedSubject != null){
                        Homework(selectedSubject!, selectedDate.year == 10 ? selectedSubject!.getNextDate()! : selectedDate, homeworkController.text);
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
          ),
        )
    );
  }
}
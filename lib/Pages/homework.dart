import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);
  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {
  final homeworkController = TextEditingController();
  Subject? selectedSubject;

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
        child:
        Expanded(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: homeworkController,
                decoration: const InputDecoration (
                  border: OutlineInputBorder(),
                  labelText: 'Hausaufgaben',
                ),
              ),
              DropdownButton<Subject>(
                value:selectedSubject ,
                hint: const Text("Fach"),
                items: getDropdowns(),
                onChanged: (Subject? newValue) {
                  setState(() {
                  selectedSubject = newValue!;
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton (
                    onPressed: (){
                      if(homeworkController.text.isNotEmpty && selectedSubject != null){
                        Homework(selectedSubject!, selectedSubject!.getNextDate()!, homeworkController.text);
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
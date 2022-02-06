import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);
  @override
  State<HomeworkPage> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<HomeworkPage> {
  final homeworkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        backButton: true,
        title: "Neue Hausaufgabe",
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: homeworkController,
                decoration: const InputDecoration (
                  border: OutlineInputBorder(),
                  labelText: 'Hausaufgaben',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton (
                    onPressed: (){
                      Homework(TimeTable.subjects[0], TimeTable.subjects[0].getNextDate()!, homeworkController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text("SUssy baki", style: AppDesign.current.textStyles.buttonText),
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}
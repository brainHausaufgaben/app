import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({Key? key}) : super(key: key);

  final subjectController = TextEditingController();
  Color pickerColor = Colors.red;

  @override
  State<SubjectPage> createState() => _SubjectPage();
}

class _SubjectPage extends State<SubjectPage> {


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
        title: "Neues Fach",
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                  controller: widget.subjectController,
                  autocorrect: true
              ),
              TextButton(
                onPressed: () {showDialog(
                  context: context,
                  child:
                )},
                child: Text("ok"),
              ),
              MaterialPicker(pickerColor: widget.pickerColor,portraitOnly: true, onColorChanged: (color){print("ok");}),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton (
                    onPressed: (){

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
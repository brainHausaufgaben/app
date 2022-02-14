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
                  builder: (BuildContext _test) {
                    return AlertDialog(
                      actions: const [
                        Text("Abbrechen"),
                        Text("Bestätigen")
                      ],
                      title: const Text("Farbe auswählen"),
                      content: MaterialPicker(pickerColor: widget.pickerColor, onColorChanged: (color){
                        setState(() {
                          widget.pickerColor = color;
                        });
                        Navigator.pop(context);
                      }),
                    );
                  }
                );},
                child: Text("ok"),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton (
                    onPressed: (){
                      Subject(widget.subjectController.text, widget.pickerColor);
                      Navigator.pop(context);
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
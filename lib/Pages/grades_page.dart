import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key? key, this.previousGrade}) : super(key: key) {
  }

  Grade? previousGrade;
  final subjectController = TextEditingController();
  Color pickerColor = Colors.red;

  @override
  State<GradesPage> createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
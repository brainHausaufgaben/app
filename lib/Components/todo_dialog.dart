import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ToDoDialog();
}

class _ToDoDialog extends State<ToDoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("To Do", style: AppDesign.textStyles.alertDialogHeader)
    );
  }
}
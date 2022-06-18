import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class EventSubpage extends StatefulWidget {
  EventSubpage({Key? key, this.previousEvent}) : super(key: key) {
    titleController.text = previousEvent?.name ?? "";
    descriptionController.text = previousEvent?.description ?? "";
    selectedDate = previousEvent?.dueTime ?? DateTime.now();
  }

  Event? previousEvent;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime selectedDate;

  @override
  State<EventSubpage> createState() => _EventSubpage();
}

class _EventSubpage extends State<EventSubpage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: 10,
            children: [
              CustomTextField(
                controller: widget.titleController,
                placeHolder: "Event Titel",
                autocorrect: true,
                maxLines: 1,
              ),
              CustomTextField(
                controller: widget.descriptionController,
                placeHolder: "Event Beschreibung",
                autocorrect: true,
                maxLines: 5,
              ),
              CustomDateButton(
                  value: widget.selectedDate,
                  text: "Nächste Stunde",
                  onDateSelect: (value) {
                    setState((){
                      widget.selectedDate = value;
                    });
                  }
              )
            ],
          ),
        ]
    );
  }
}
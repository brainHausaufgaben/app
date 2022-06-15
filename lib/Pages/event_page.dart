import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  EventPage({Key? key, this.previousEvent}) : super(key: key) {
    titleController.text = previousEvent?.name ?? "";
    descriptionController.text = previousEvent?.description ?? "";
    selectedDate = previousEvent?.dueTime ?? DateTime.now();
  }

  Event? previousEvent;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime selectedDate;

  @override
  State<EventPage> createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        backButton: true,
        title: widget.previousEvent != null ? "Event Bearbeiten" : "Neues Event",
        child: Column(
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton (
                        onPressed: () {
                          if (widget.titleController.text.isNotEmpty && widget.descriptionController.text.isNotEmpty) {
                            if (widget.previousEvent == null) {
                              Event(widget.selectedDate, widget.titleController.text, widget.descriptionController.text);
                            } else {
                              widget.previousEvent!.edit(widget.selectedDate, widget.titleController.text, widget.descriptionController.text);
                            }
                            BrainApp.notifier.notifyOfChanges();
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(widget.previousEvent == null ? "Hinzufügen" : "Bearbeiten", style: AppDesign.current.textStyles.buttonText),
                        )
                    ),
                  ),
                  if (widget.previousEvent != null) Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton (
                          onPressed: () {
                            TimeTable.removeEvent(widget.previousEvent!);
                            BrainApp.notifier.notifyOfChanges();
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Icon(Icons.delete_forever),
                          )
                      )
                  )
                ]
            )
        ),
    );
  }
}
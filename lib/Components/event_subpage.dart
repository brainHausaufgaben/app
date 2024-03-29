import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:flutter/material.dart';

class EventSubpage extends StatefulWidget {
  EventSubpage({Key? key, this.previousEvent, this.withPadding = false}) : super(key: key) {
    titleController.text = previousEvent?.name ?? "";
    descriptionController.text = previousEvent?.description ?? "";
    selectedDate = previousEvent?.dueTime ?? CalendarPage.selectedDay;
  }

  final Event? previousEvent;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime selectedDate;
  final bool withPadding;

  @override
  State<EventSubpage> createState() => _EventSubpage();
}

class _EventSubpage extends State<EventSubpage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.withPadding ? 5 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              runSpacing: 10,
              children: [
                BrainTextField(
                  controller: widget.titleController,
                  placeholder: "Termin Titel",
                  maxLines: 1,
                ),
                BrainTextField(
                  controller: widget.descriptionController,
                  placeholder: "Termin Beschreibung",
                  maxLines: 5,
                ),
                BrainDateButton(
                    value: widget.selectedDate,
                    text: "Nächste Stunde",
                    onDateSelect: (value) {
                      setState((){
                        widget.selectedDate = value;
                      });
                    }
                )
              ]
            )
          ]
      )
    );
  }
}
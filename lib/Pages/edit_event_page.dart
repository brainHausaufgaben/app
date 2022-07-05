import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Components/event_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/brain_toast.dart';

class EditEventPage extends StatefulWidget {
  EditEventPage({Key? key, required this.previousEvent}) : super(key: key) {
    eventSubpage = EventSubpage(previousEvent: previousEvent);
  }

  final Event previousEvent;
  EventSubpage eventSubpage = EventSubpage();

  @override
  State<EditEventPage> createState() => _TestPage();
}

class _TestPage extends State<EditEventPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      backButton: true,
      title: "Event Bearbeiten",
      child: widget.eventSubpage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  String title = widget.eventSubpage.titleController.text;
                  String description = widget.eventSubpage.descriptionController.text;
                  DateTime date = widget.eventSubpage.selectedDate;

                  if (title.isEmpty) {
                    BrainToast toast = BrainToast(text: "Du hast keinen Titel angegeben!");
                    toast.show(context);
                    return;
                  } else {
                    widget.previousEvent.edit(date, title, description);
                    BrainApp.notifier.notifyOfChanges();
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Bearbeiten",
                    style: AppDesign.current.textStyles.buttonText),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton(
                onPressed: () {
                  TimeTable.removeEvent(widget.previousEvent);
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

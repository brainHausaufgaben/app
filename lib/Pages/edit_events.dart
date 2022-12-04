import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/event_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/animated_delete_button.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({Key? key}) : super(key: key);

  @override
  State<EditEventPage> createState() => _TestPage();
}

class _TestPage extends State<EditEventPage> {
  Event? previousEvent;
  EventSubpage eventSubpage = EventSubpage();

  void getData() {
    Event data = ModalRoute.of(context)!.settings.arguments as Event;
    previousEvent = data;
    eventSubpage = EventSubpage(previousEvent: data);
  }

  @override
  void didChangeDependencies() {
    if (previousEvent == null) getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      secondaryPage: true,
      title: "Termin Bearbeiten",
      pageSettings: const PageSettings(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  String title = eventSubpage.titleController.text;
                  String description = eventSubpage.descriptionController.text;
                  DateTime date = eventSubpage.selectedDate;

                  if (title.isEmpty) {
                    BrainToast toast = BrainToast(text: "Du hast keinen Titel angegeben!");
                    toast.show();
                    BrainVibrations.errorVibrate();
                    return;
                  } else {
                    previousEvent!.edit(date, title, description);
                    BrainApp.notifier.notifyOfChanges();
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Bearbeiten",
                    style: AppDesign.textStyles.buttonText
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AnimatedDeleteButton(
                onDelete: () {
                  TimeTable.removeEvent(previousEvent!);
                  BrainApp.notifier.notifyOfChanges();
                  Navigator.pop(context);
                }
              )
            )
          ]
        )
      ),
      body: eventSubpage
    );
  }
}
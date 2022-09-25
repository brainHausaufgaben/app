import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/event_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

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
    setState(() {
      previousEvent = data;
      eventSubpage = EventSubpage(previousEvent: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (previousEvent == null) getData();

    return PageTemplate(
      backButton: true,
      title: "Termin Bearbeiten",
      child: eventSubpage,
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
              child: ElevatedButton(
                onPressed: () {
                  TimeTable.removeEvent(previousEvent!);
                  BrainApp.notifier.notifyOfChanges();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(Icons.delete_forever, color: AppDesign.colors.contrast),
                )
              )
            )
          ]
        )
      ),
    );
  }
}

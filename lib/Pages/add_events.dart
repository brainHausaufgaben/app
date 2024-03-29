import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/event_subpage.dart';
import 'package:brain_app/Components/test_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class AddEventsPage extends StatefulWidget {
  const AddEventsPage({Key? key}) : super(key: key);

  @override
  State<AddEventsPage> createState() => _EventsPage();
}

class _EventsPage extends State<AddEventsPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<Widget> subpages = [
    EventSubpage(withPadding: true),
    TestSubpage(withPadding: true)
  ];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void addEvent() {
    EventSubpage eventSubpage = subpages[tabController.index] as EventSubpage;

    String title = eventSubpage.titleController.text;
    String description = eventSubpage.descriptionController.text;
    DateTime date = eventSubpage.selectedDate;

    if (title.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Titel angegeben!");
      toast.show();
      BrainVibrations.errorVibrate();
      return;
    } else {
      Event(date, title, description);

      BrainApp.notifier.notifyOfChanges();
      Navigator.pop(context);
    }
  }

  void addTest() {
    TestSubpage testSubpage = subpages[tabController.index] as TestSubpage;

    String description = testSubpage.descriptionController.text;
    Subject? subject = testSubpage.selectedSubject;
    DateTime date = testSubpage.selectedDate;

    if (subject == null) {
      BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
      toast.show();
      BrainVibrations.errorVibrate();
      return;
    } else {
      Test(subject, date, description);

      BrainApp.notifier.notifyOfChanges();
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: PageTemplate(
        secondaryPage: true,
        title: "Neues Event",
        pageSettings: PageSettings(
          floatingHeaderIsCentered: true,
          floatingHeaderBorderRadius: BorderRadius.circular(20),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
        floatingHeader: Container(
          constraints: const BoxConstraints(maxWidth: 250, minHeight: 55),
          decoration: BoxDecoration(
              color: AppDesign.colors.secondaryBackground,
              borderRadius: BorderRadius.circular(20)
          ),
          clipBehavior: Clip.antiAlias,
          child: DefaultTextStyle(
            style: AppDesign.textStyles.tab,
            child: Theme(
              data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent
              ),
              child: TabBar(
                controller: tabController,
                labelStyle: AppDesign.textStyles.tab,
                labelColor: AppDesign.colors.contrast,
                unselectedLabelColor: AppDesign.colors.text,
                indicator: BoxDecoration(
                    color: AppDesign.colors.primary,
                    borderRadius: BorderRadius.circular(20)
                ),
                tabs: const [
                  Tab(child: Text("Termin")),
                  Tab(child: Text("Test"))
                ]
              )
            )
          )
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton (
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppDesign.colors.primary
                          ),
                          onPressed: () {
                            switch (subpages[tabController.index].runtimeType) {
                              case EventSubpage:
                                addEvent();
                                break;
                              case TestSubpage:
                                addTest();
                                break;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text("Hinzufügen", style: AppDesign.textStyles.buttonText),
                          )
                      )
                  )
                ]
            )
        ),
        body: SizedBox(
          height: 400,
          child: NotificationListener<OverscrollNotification> (
            onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
            child: TabBarView(
              controller: tabController,
              children: subpages,
            )
          )
        )
      )
    );
  }
}
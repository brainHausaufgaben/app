import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/event_subpage.dart';
import 'package:brain_app/Components/test_subpage.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/brain_toast.dart';

class EventsPage extends StatefulWidget {
  EventsPage({Key? key}) : super(key: key);

  final List<Widget> subpages = [EventSubpage(), TestSubpage()];

  @override
  State<EventsPage> createState() => _EventsPage();
}

class _EventsPage extends State<EventsPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void addEvent() {
    EventSubpage eventSubpage = widget.subpages[tabController.index] as EventSubpage;

    String title = eventSubpage.titleController.text;
    String description = eventSubpage.descriptionController.text;
    DateTime date = eventSubpage.selectedDate;

    if (title.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Titel angegeben!");
      toast.show(context);
      return;
    } else {
      Event(date, title, description);

      BrainApp.notifier.notifyOfChanges();
      Navigator.pop(context);
    }
  }

  void addTest() {
    TestSubpage testSubpage = widget.subpages[tabController.index] as TestSubpage;

    String description = testSubpage.descriptionController.text;
    Subject? subject = testSubpage.selectedSubject;
    DateTime date = testSubpage.selectedDate;

    if (description.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keine Inhalte angegeben!");
      toast.show(context);
      return;
    } else if (subject == null) {
      BrainToast toast = BrainToast(text: "Du hast kein Fach angegeben!");
      toast.show(context);
      return;
    } else {
      Test(subject, date, description);

      BrainApp.notifier.notifyOfChanges();
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        backButton: true,
        title: "Neues Event",
        child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: AppDesign.current.boxStyle.borderRadius
                        ),
                        expandedHeight: 0,
                        titleSpacing: 0,
                        primary: false,
                        backgroundColor: Colors.transparent,
                        elevation: 2,
                        shadowColor: Colors.grey.shade50,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        title: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color:  AppDesign.current.boxStyle.backgroundColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TabBar(
                            controller: tabController,
                            labelStyle: AppDesign.current.textStyles.tab,
                            labelColor: AppDesign.current.textStyles.contrastColor,
                            unselectedLabelColor: AppDesign.current.textStyles.color,
                            indicator: BoxDecoration(
                                color: AppDesign.current.primaryColor
                            ),
                            tabs: const [
                              Tab(text: "Event", height: 55),
                              Tab(text: "Test", height: 55)
                            ],
                          ),
                        )
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TabBarView(
                    controller: tabController,
                    children: widget.subpages,
                  ),
                )
            )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton (
                          onPressed: () {
                            switch (widget.subpages[tabController.index].runtimeType) {
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
                            child: Text("Hinzufügen", style: AppDesign.current.textStyles.buttonText),
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}
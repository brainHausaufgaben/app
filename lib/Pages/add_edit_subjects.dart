import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/brain_toast.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({Key? key}) : super(key: key);

  Subject? previousSubject;
  LinkedSubject? previousLinkedSubject;

  TextEditingController subjectController = TextEditingController();
  TextEditingController linkedSubjectController = TextEditingController();

  Color pickerColor = Colors.red;
  Color linkedPickerColor = Colors.red;

  List<Subject> linkedSubjects = [TimeTable.emptySubject, TimeTable.emptySubject];

  TextEditingController firstEvaluationController = TextEditingController(text: "1");
  TextEditingController secondEvaluationController = TextEditingController(text: "1");

  bool alreadyFetchedData = false;

  @override
  State<SubjectPage> createState() => _SubjectPage();
}

class _SubjectPage extends State<SubjectPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    widget.subjectController.dispose();
    widget.linkedSubjectController.dispose();
    widget.firstEvaluationController.dispose();
    widget.secondEvaluationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void getData() {
    widget.alreadyFetchedData = true;
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    switch (data.runtimeType) {
      case LinkedSubject:
        setState(() {
          widget.previousLinkedSubject = data;
          widget.linkedSubjectController.text = data.name;
          widget.linkedPickerColor = data.color;
          widget.linkedSubjects = data.subjects;
          widget.firstEvaluationController.text = data.evaluations[0].toString();
          widget.secondEvaluationController.text = data.evaluations[1].toString();
        });
        break;
      case Subject:
        setState(() {
          widget.previousSubject = data;
          widget.subjectController.text = data.name;
          widget.pickerColor = data.color;
        });
        break;
      default:
        break;
    }
  }

  bool evaluateLinkedSubjectEntries() {
    if (widget.linkedSubjectController.text.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Namen angegeben!");
      toast.show();
      return false;
    } else if (widget.linkedSubjects.contains(TimeTable.emptySubject)) {
      BrainToast toast = BrainToast(text: "Du musst 2 Fächer auswählen!");
      toast.show();
      return false;
    } else {
      for (Subject subject in TimeTable.subjects) {
        if (subject.name == widget.linkedSubjectController.text) {
          if (widget.previousLinkedSubject?.id != subject.id) {
            BrainToast toast = BrainToast(
                text: "Ein Fach oder eine Verbindung mit diesem Namen existiert bereits!");
            toast.show();
            return false;
          }
        }
      }
    }
    return true;
  }


  Widget getLinkedSubjectEntries() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
          children: [
            Flex(
                direction: Axis.horizontal,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: BrainColorPicker(
                          pickerColor: widget.linkedPickerColor,
                          onColorSelect: (color) {
                            setState(() {
                              widget.linkedPickerColor = color;
                            });
                            Navigator.of(NavigationHelper.rootKey.currentContext!).pop();
                          }
                      )
                  ),
                  Flexible(
                      child: BrainTextField(
                          controller: widget.linkedSubjectController,
                          placeholder: "Verbindungs Name",
                          maxLines: 1,
                          maxLength: 20
                      )
                  )
                ]
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          child: BrainDropdown(
                              defaultText: "1. Fach",
                              dialogTitle: "Wähle ein Fach",
                              items: BrainDropdown.getSubjectDropdowns(),
                              currentValue: widget.linkedSubjects[0],
                              onChanged: (value) {
                                setState(() {
                                  widget.linkedSubjects[0] = value;
                                });
                              }
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          constraints: const BoxConstraints(
                              maxWidth: 100
                          ),
                          child: BrainTextField(
                            placeholder: "Wertung",
                            controller: widget.firstEvaluationController,
                          )
                      )
                    ]
                )
            ),
            Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      child: BrainDropdown(
                          defaultText: "2. Fach",
                          dialogTitle: "Wähle ein Fach",
                          items: BrainDropdown.getSubjectDropdowns(),
                          currentValue: widget.linkedSubjects[1],
                          onChanged: (value) {
                            setState(() {
                              widget.linkedSubjects[1] = value;
                            });
                          }
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(
                          maxWidth: 100
                      ),
                      child: BrainTextField(
                        placeholder: "Wertung",
                        controller: widget.secondEvaluationController,
                      )
                  )
                ]
            )
          ]
      )
    );
  }

  bool evaluateSubjectEntries() {
    if (widget.subjectController.text.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Namen angegeben!");
      toast.show();
      return false;
    } else {
      for (Subject subject in TimeTable.subjects) {
        if (subject.name == widget.subjectController.text) {
          if (widget.previousSubject?.id != subject.id) {
            BrainToast toast = BrainToast(
                text: "Ein Fach oder eine Verbindung mit diesem Namen existiert bereits!");
            toast.show();
            return false;
          }
        }
      }
    }
    return true;
  }

  Widget getSubjectEntries() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: BrainColorPicker(
                    pickerColor: widget.pickerColor,
                    onColorSelect: (color) {
                      setState(() {
                        widget.pickerColor = color;
                      });
                      Navigator.of(NavigationHelper.rootKey.currentContext!).pop();
                    }
                )
            ),
            Flexible(
                child: BrainTextField(
                  controller: widget.subjectController,
                  placeholder: "Fach Name",
                  maxLines: 1,
                  maxLength: 20,
                )
            )
          ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.alreadyFetchedData) getData();

    return DefaultTabController(
      length: 2,
      child: PageTemplate(
          backButton: true,
          title: widget.previousSubject != null ? "Fach Bearbeiten" : "Neues Fach",
          pageSettings: PageSettings(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingHeaderIsCentered: true,
            floatingHeaderBorderRadius: BorderRadius.circular(100)
          ),
          floatingHeader: widget.previousLinkedSubject == widget.previousSubject
              ? Container(
              constraints: const BoxConstraints(maxWidth: 350, minHeight: 55),
              decoration: BoxDecoration(
                  color: AppDesign.colors.secondaryBackground,
                  borderRadius: BorderRadius.circular(100)
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
                              borderRadius: BorderRadius.circular(100)
                          ),
                          tabs: const [
                            Tab(child: Text("Note")),
                            Tab(child: Text("Verbindung"))
                          ]
                      )
                  )
              )
          ) : null,
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
                            if (widget.previousSubject == widget.previousLinkedSubject) {
                              if (tabController.index == 0) {
                                if (!evaluateSubjectEntries()) return;
                                Navigator.of(context).pop(Subject(widget.subjectController.text.trim(), widget.pickerColor));
                              } else {
                                if (!evaluateLinkedSubjectEntries()) return;
                                Navigator.of(context).pop(LinkedSubject(
                                  widget.linkedSubjectController.text.trim(),
                                  widget.linkedPickerColor,
                                  widget.linkedSubjects,
                                  [int.parse(widget.firstEvaluationController.text), int.parse(widget.secondEvaluationController.text)]
                                ));
                              }
                            } else if (widget.previousSubject != null) {
                              if (!evaluateSubjectEntries()) return;
                              TimeTable.getSubject(widget.previousSubject!.id)!.edit(widget.subjectController.text, widget.pickerColor);
                              Navigator.of(context).pop();
                            } else {
                              if (!evaluateLinkedSubjectEntries()) return;
                              TimeTable.getSubject(widget.previousLinkedSubject!.id)!.edit(widget.linkedSubjectController.text, widget.linkedPickerColor);
                              Navigator.of(context).pop();
                            }

                            BrainApp.notifier.notifyOfChanges();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                                widget.previousSubject == null ? "Hinzufügen" : "Bearbeiten",
                                style: AppDesign.textStyles.buttonText
                            )
                          )
                      )
                    ),
                    if (widget.previousSubject != null || widget.previousLinkedSubject != null) Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ElevatedButton (
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppDesign.colors.primary
                            ),
                            onPressed: () {
                              TimeTable.deleteSubject(widget.previousSubject!);
                              Navigator.of(context).pop();
                              BrainApp.notifier.notifyOfChanges();
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
          child: widget.previousSubject == widget.previousLinkedSubject 
              ? SizedBox(
                height: 300,
                child: NotificationListener<OverscrollNotification> (
                    onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
                    child: TabBarView(
                      controller: tabController,
                      children: [getSubjectEntries(), getLinkedSubjectEntries()],
                    )
                )
            ) : (widget.previousSubject != null ? getSubjectEntries() : getLinkedSubjectEntries())
      )
    );
  }
}
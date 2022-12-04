import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

import '../Components/animated_delete_button.dart';
import '../Components/brain_toast.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPage();
}

class _SubjectPage extends State<SubjectPage> with SingleTickerProviderStateMixin {
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
  
  late TabController tabController;
  
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    subjectController.dispose();
    linkedSubjectController.dispose();
    firstEvaluationController.dispose();
    secondEvaluationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void getData() {
    alreadyFetchedData = true;
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    switch (data.runtimeType) {
      case LinkedSubject:
        previousLinkedSubject = data;
        linkedSubjectController.text = data.name;
        linkedPickerColor = data.color;
        linkedSubjects = data.subjects;
        firstEvaluationController.text = data.evaluations[0].toString();
        secondEvaluationController.text = data.evaluations[1].toString();
        break;
      case Subject:
        previousSubject = data;
        subjectController.text = data.name;
        pickerColor = data.color;
        break;
      default:
        break;
    }
  }

  bool evaluateLinkedSubjectEntries() {
    if (linkedSubjectController.text.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Namen angegeben!");
      BrainVibrations.errorVibrate();
      toast.show();
      return false;
    } else if (linkedSubjects.contains(TimeTable.emptySubject)) {
      BrainToast toast = BrainToast(text: "Du musst 2 Fächer auswählen!");
      BrainVibrations.errorVibrate();
      toast.show();
      return false;
    } else {
      for (Subject subject in TimeTable.subjects) {
        if (subject.name == linkedSubjectController.text) {
          if (previousLinkedSubject?.id != subject.id) {
            BrainToast toast = BrainToast(
                text: "Ein Fach oder eine Verbindung mit diesem Namen existiert bereits!");
            BrainVibrations.errorVibrate();
            toast.show();
            return false;
          }
        }
      }
    }
    return true;
  }


  Widget getLinkedSubjectEntries() {
    List<BrainDropdownEntry> firstSubjectEntries = BrainDropdown.getSubjectDropdowns();
    firstSubjectEntries.removeWhere((dropdownEntry) {
      return (dropdownEntry.value == linkedSubjects[1]) || (TimeTable.noAverageSubjects.contains(dropdownEntry.value) && previousLinkedSubject == null);
    });

    List<BrainDropdownEntry> secondSubjectEntries = BrainDropdown.getSubjectDropdowns();
    secondSubjectEntries.removeWhere((dropdownEntry) {
      return (dropdownEntry.value == linkedSubjects[0]) || (TimeTable.noAverageSubjects.contains(dropdownEntry.value) && previousLinkedSubject == null);
    });

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
                          pickerColor: linkedPickerColor,
                          onColorSelect: (color) {
                            setState(() {
                              linkedPickerColor = color;
                            });
                            Navigator.of(NavigationHelper.rootKey.currentContext!).pop();
                          }
                      )
                  ),
                  Flexible(
                      child: BrainTextField(
                          controller: linkedSubjectController,
                          placeholder: "Verbindungs Name",
                          maxLines: 1,
                          maxLength: 30
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
                              items: firstSubjectEntries,
                              currentValue: linkedSubjects[0],
                              onChanged: (value) {
                                setState(() {
                                  linkedSubjects[0] = value;
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
                            digitsOnly: true,
                            maxLength: 5,
                            placeholder: "Wertung",
                            controller: firstEvaluationController,
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
                          items: secondSubjectEntries,
                          currentValue: linkedSubjects[1],
                          onChanged: (value) {
                            setState(() {
                              linkedSubjects[1] = value;
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
                        digitsOnly: true,
                        maxLength: 5,
                        placeholder: "Wertung",
                        controller: secondEvaluationController,
                      )
                  )
                ]
            )
          ]
      )
    );
  }

  bool evaluateSubjectEntries() {
    if (subjectController.text.isEmpty) {
      BrainToast toast = BrainToast(text: "Du hast keinen Namen angegeben!");
      toast.show();
      BrainVibrations.errorVibrate();
      return false;
    } else {
      for (Subject subject in TimeTable.subjects) {
        if (subject.name == subjectController.text) {
          if (previousSubject?.id != subject.id) {
            BrainToast toast = BrainToast(
                text: "Ein Fach oder eine Verbindung mit diesem Namen existiert bereits!");
            toast.show();
            BrainVibrations.errorVibrate();
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
                    pickerColor: pickerColor,
                    onColorSelect: (color) {
                      setState(() {
                        pickerColor = color;
                      });
                      Navigator.of(NavigationHelper.rootKey.currentContext!).pop();
                    }
                )
            ),
            Flexible(
                child: BrainTextField(
                  controller: subjectController,
                  placeholder: "Fach Name",
                  maxLines: 1,
                  maxLength: 30,
                )
            )
          ]
      )
    );
  }

  @override
  void didChangeDependencies() {
    if (!alreadyFetchedData) getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PageTemplate(
          secondaryPage: true,
          title: previousSubject != null ? "Fach Bearbeiten" : (previousLinkedSubject != null ? "Verbindung Bearbeiten" : "Neues Fach"),
          pageSettings: PageSettings(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingHeaderIsCentered: true,
            floatingHeaderBorderRadius: BorderRadius.circular(20)
          ),
          secondaryTitleButton: previousSubject != null ? null : BrainTitleButton(
              action: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: AppDesign.colors.secondaryBackground,
                      title: Text("Verbindungen", style: AppDesign.textStyles.alertDialogHeader),
                      content: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Text(
                          "Mit Hilfe von Verbindungen können die Durschnitte von 2 Fächern, bevor der allgemeine Durchschnitt ermittelt wird, zusammengerechnet werden."
                          "\nDas geschieht unter Berücksichtung der Wertungen, also kann etwa eines der Fächer 2x so viel zu der kombinierten Note beitragen"
                          "\n\n(zB. können Geschichte und Sozialkunde mit einer Wertung von 2 zu 1 verbunden werden)",
                          style: AppDesign.textStyles.alertDialogDescription,
                        )
                      )
                    );
                  }
                );
              },
              icon: Icons.info_outline_rounded,
              semantics: "Informationen zu Verbindungen"
          ),
          floatingHeader: previousLinkedSubject == previousSubject
              ? Container(
              constraints: const BoxConstraints(maxWidth: 350, minHeight: 55),
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
                            Tab(child: Text("Fach")),
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
                            if (previousSubject == previousLinkedSubject) {
                              if (tabController.index == 0) {
                                if (!evaluateSubjectEntries()) return;
                                Navigator.of(context).pop(Subject(subjectController.text.trim(), pickerColor));
                              } else {
                                if (!evaluateLinkedSubjectEntries()) return;
                                Navigator.of(context).pop(LinkedSubject(
                                  linkedSubjectController.text.trim(),
                                  linkedPickerColor,
                                  linkedSubjects,
                                  [int.parse(firstEvaluationController.text), int.parse(secondEvaluationController.text)]
                                )..addToList());
                              }
                            } else if (previousSubject != null) {
                              if (!evaluateSubjectEntries()) return;
                              TimeTable.getSubject(previousSubject!.id)!.edit(subjectController.text, pickerColor);
                              Navigator.of(context).pop();
                            } else {
                              if (!evaluateLinkedSubjectEntries()) return;
                              previousLinkedSubject!.editLinked(
                                  linkedSubjectController.text.trim(),
                                  linkedPickerColor,
                                  linkedSubjects,
                                  [int.parse(firstEvaluationController.text), int.parse(secondEvaluationController.text)]
                              );
                              Navigator.of(context).pop();
                            }

                            BrainApp.notifier.notifyOfChanges();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                                previousSubject == previousLinkedSubject ? "Hinzufügen" : "Bearbeiten",
                                style: AppDesign.textStyles.buttonText
                            )
                          )
                      )
                    ),
                    if (previousSubject != null || previousLinkedSubject != null) Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AnimatedDeleteButton(
                            onDelete: () {
                              if (previousSubject != null) {
                                TimeTable.deleteSubject(previousSubject!);
                              } else {
                                TimeTable.deleteLinkedSubject(previousLinkedSubject!);
                              }
                              Navigator.of(context).pop();
                              BrainApp.notifier.notifyOfChanges();
                            }
                        )
                    )
                  ]
              )
          ),
          body: previousSubject == previousLinkedSubject 
              ? SizedBox(
                height: 300,
                child: NotificationListener<OverscrollNotification> (
                    onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
                    child: TabBarView(
                      controller: tabController,
                      children: [getSubjectEntries(), getLinkedSubjectEntries()],
                    )
                )
            ) : (previousSubject != null ? getSubjectEntries() : getLinkedSubjectEntries())
      )
    );
  }
}
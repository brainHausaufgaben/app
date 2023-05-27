import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/brain_dismissible.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_notes_dialog.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Backend/todo.dart';
import '../../Backend/todo_manager.dart';
import '../../Components/todo_dialog.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}): super(key: key);

  static DateTime selectedDay = DateTime.now();

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  List<Widget> getSelectedNotes() {
    List<Widget> boxes = [];
    List<Note> notes = TimeTable.getNotes(CalendarPage.selectedDay);

    for (Note note in notes) {
      boxes.add(
        BrainButton(
          action: () {
            showDialog(
              context: context,
              builder: (context) {
                return BrainNotesDialog(
                  note: note
                );
              }
            );
          },
          dense: true,
          centered: false,
          icon: Icons.edit,
          child: Text(note.description, style: AppDesign.textStyles.pointElementPrimary)
        )
      );
    }

    return boxes;
  }

  List<Widget> getSelectedEvents() {
    List<Widget> boxes = [];
    List<Event> events = TimeTable.getEvents(CalendarPage.selectedDay);
    for (int i=0; i<events.length; i++) {
      boxes.add(
          BrainButton(
            centered: false,
            dense: true,
            action: () => NavigationHelper.pushNamed(context, "editEventsPage", payload: events[i]),
            icon: Icons.edit,
            child: PointElement(
              color: AppDesign.colors.primary,
              primaryText: events[i].name,
              child: events[i].description.isEmpty ? null : Text(events[i].description, style: AppDesign.textStyles.pointElementSecondary),
            )
          )
      );
    }

    return boxes;
  }

  List<Widget> getSelectedTests() {
    List<Widget> boxes = [];
    List<Test> tests = TimeTable.getTests(CalendarPage.selectedDay);

    for (int i=0; i<tests.length; i++) {
      boxes.add(
        BrainButton(
          centered: false,
          action: () => NavigationHelper.pushNamed(context, "editTestPage", payload: tests[i]),
          icon: Icons.edit,
          dense: true,
          child: PointElement(
            color: tests[i].subject.color,
            primaryText: tests[i].subject.name,
            child: tests[i].description.isEmpty ? null : Text(tests[i].description,
              style: AppDesign.textStyles.pointElementSecondary),
          )
        )
      );
    }

    return boxes;
  }

  Widget getSelectedHomework() {
    List<Widget> entries = [];

    for (Subject subject in TimeTable.subjects) {
      List<Homework> homework = TimeTable.getHomework(CalendarPage.selectedDay, subject);
      List<BrainDismissible> dismissableBoxes = [];

      for (Homework _homework in homework) {
        dismissableBoxes.add(
          BrainDismissible(homework: _homework)
        );
      }

      if (dismissableBoxes.isNotEmpty) {
        entries.add(
            PointElement(
                color: subject.color,
                primaryText: subject.name,
                child: Wrap(
                  runSpacing: 3,
                  children: dismissableBoxes,
                )
            )
        );
      }
    }

    return Box(
      child: Wrap(
        runSpacing: 10,
        children: entries,
      )
    );
  }

  List<Homework> getHomeworkByDay(DateTime day) {
    List<Homework> homework = [];

    for (Subject subject in TimeTable.subjects) {
      homework.addAll(TimeTable.getHomework(day, subject));
    }

    return homework;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 1;
            NavigationHelper.pushNamedReplacement(context, "home");
          }
        }
      },
      child: PageTemplate(
          pageSettings: const PageSettings(bottomPadding: 45),
          title: "Kalender",
          floatingActionButton: BrainMenuButton(
            defaultAction: () => NavigationHelper.pushNamed(context, "addEventPage"),
            defaultLabel: "Neu",
          ),
          secondaryTitleButton: StatefulBuilder(
              builder: (context, setBuilderState) {
                return BrainTitleButton(
                    indicator: ToDoManager.getDoneStateToDos(false).isEmpty ? null : ToDoManager.getDoneStateToDos(false).length,
                    indicatorColor: () {
                      switch (ToDoManager.getHighestImportance()) {
                        case ToDoImportance.low:
                          return Colors.green;
                        case ToDoImportance.mid:
                          return Colors.deepOrangeAccent;
                        case ToDoImportance.high:
                          return Colors.red;
                      }
                    }(),
                    icon: Icons.task_outlined,
                    semantics: "To Do",
                    action: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const ToDoDialog();
                          }
                      ).then((value) {
                        setBuilderState(() {});
                      });
                    }
                );
              }
          ),
          body: Wrap(
              runSpacing: 20,
              children: [
                Box(
                    child: TableCalendar(
                        calendarFormat: CalendarFormat.values[BrainApp.preferences["calendarFormat"]],
                        availableCalendarFormats: const {
                          CalendarFormat.month : "Monat",
                          CalendarFormat.week : "Woche",
                          CalendarFormat.twoWeeks : "2 Wochen"
                        },
                        locale: "de_DE",
                        firstDay: DateTime.utc(2018, 10, 16),
                        lastDay: DateTime.now().add(const Duration(days:730)),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        focusedDay: CalendarPage.selectedDay,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(color: AppDesign.colors.text),
                          weekendTextStyle: TextStyle(color: AppDesign.colors.text),
                          outsideTextStyle: TextStyle(color: AppDesign.colors.text05),
                          todayDecoration: BoxDecoration(color: AppDesign.colors.background, shape: BoxShape.circle),
                          todayTextStyle: TextStyle(color: AppDesign.colors.text),
                          selectedDecoration: BoxDecoration(color: AppDesign.colors.primary, shape: BoxShape.circle),
                          selectedTextStyle: TextStyle(color: AppDesign.colors.contrast),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: AppDesign.colors.text),
                            weekendStyle: TextStyle(color: AppDesign.colors.text)
                        ),
                        headerStyle: HeaderStyle(
                          headerPadding: const EdgeInsets.only(bottom: 10),
                          titleTextStyle: TextStyle(color: AppDesign.colors.text, fontSize: 18, fontWeight: FontWeight.w600),
                          titleCentered: true,
                          formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppDesign.colors.text)
                          ),
                          formatButtonTextStyle: TextStyle(color: AppDesign.colors.text),
                          leftChevronIcon: Icon(Icons.chevron_left, color: AppDesign.colors.text),
                          rightChevronIcon: Icon(Icons.chevron_right, color: AppDesign.colors.text),
                        ),
                        calendarBuilders: CalendarBuilders(
                          singleMarkerBuilder: (context, date, event) {
                            switch (event.runtimeType) {
                              case Event:
                                return Container(
                                    decoration: BoxDecoration(
                                      color: AppDesign.colors.primary,
                                      border: Border.all(color: AppDesign.colors.secondaryBackground, width: 1, strokeAlign: BorderSide.strokeAlignOutside)
                                    ),
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5)
                                );
                                break;
                              case Homework:
                                Homework hm = event as Homework;
                                return Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: hm.subject.color),
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5)
                                );
                              case Test:
                                Test test = event as Test;
                                return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color: test.subject.color
                                        )
                                    ),
                                    width: 9.0,
                                    height: 9.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5)
                                );
                              case Note:
                                return Container(
                                    decoration: BoxDecoration(
                                        color: date.difference(DateTime.now()).inDays != 0 ? AppDesign.colors.secondaryBackground : AppDesign.colors.background,
                                        border: Border.all(color: AppDesign.colors.primary, width: 2, strokeAlign: BorderSide.strokeAlignOutside)
                                    ),
                                    width: 5.0,
                                    height: 5.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5)
                                );
                            }
                            return null;
                          },
                        ),
                        formatAnimationCurve: Curves.easeOutBack,
                        formatAnimationDuration: const Duration(milliseconds: 500),
                        onFormatChanged: (format) {
                          setState(() {
                            BrainApp.updatePreference("calendarFormat", format.index);
                          });
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            CalendarPage.selectedDay = selectedDay;
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(CalendarPage.selectedDay, day);
                        },
                        eventLoader: (date) {
                          List<dynamic> events = [
                            ...TimeTable.getEvents(date),
                            ...getHomeworkByDay(date),
                            ...TimeTable.getTests(date),
                            ...TimeTable.getNotes(date)
                          ];
                          return events;
                        }
                    )
                ),
                if (TimeTable.getTests(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Tests",
                  children: getSelectedTests(),
                ),
                if (getHomeworkByDay(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Hausaufgaben",
                  children: [getSelectedHomework()],
                ),
                if (TimeTable.getEvents(CalendarPage.selectedDay).isNotEmpty) HeadlineWrap(
                  headline: "Termine",
                  children: getSelectedEvents(),
                ),
                HeadlineWrap(
                  headline: "Notizen",
                  action: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BrainNotesDialog();
                        }
                      );
                    },
                    child: const Text("Neu +"),
                  ),
                  children: getSelectedNotes(),
                )
              ]
          )
      )
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../main.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePage();
}

class _TimeTablePage extends State<TimeTablePage> with TickerProviderStateMixin {
  List<BrainDropdownEntry> getDropdowns() {
    List<BrainDropdownEntry> subjects = BrainDropdown.getSubjectDropdowns();

    subjects.add(BrainDropdownEntry(
      child: PointElement(
          primaryText: TimeTable.emptySubject.name,
          color: TimeTable.emptySubject.color
      ),
      value: TimeTable.emptySubject,
    ));

    return subjects;
  }

  List<Widget> getTimetableTabs() {
    List<Widget> tabs = [];

    for (int day=0; day<5; day++) {
      List<Widget> entries = [];
      for (int i=0; i<10; i++) {
        if (i == 6) {
          entries.add(
            const SizedBox(height: 10)
          );
        }
        entries.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        backgroundColor: AppDesign.colors.primary,
                        foregroundColor: AppDesign.colors.contrast,
                        minimumSize: Size.zero
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Zeiten", style: AppDesign.textStyles.alertDialogHeader),
                            backgroundColor: AppDesign.colors.secondaryBackground,
                            content: StatefulBuilder(
                              builder: (context, setBuilderState) {
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SettingsTimePicker(
                                          text: "Start",
                                          onSelect: (time) {
                                            setBuilderState(() {
                                              TimeTable.lessonTimes[i].startTime = time;
                                            });
                                          },
                                          currentTime: TimeTable.lessonTimes[i].startTime
                                      ),
                                      SettingsTimePicker(
                                          text: "Ende",
                                          onSelect: (time) {
                                            setBuilderState(() {
                                              TimeTable.lessonTimes[i].endTime = time;
                                            });
                                          },
                                          currentTime: TimeTable.lessonTimes[i].endTime
                                      )
                                    ]
                                );
                              },
                            )
                          );
                        }
                      ).then((value) {
                        SaveSystem.saveLessonTimes();
                        BrainApp.notifier.notifyOfChanges();
                      });
                    },
                    child: Text(
                      TimeTable.lessonTimes[i].startTime.format(context),
                      style: AppDesign.textStyles.pointElementSecondary.copyWith(color: AppDesign.colors.contrast)
                    )
                  )
                ),
                Expanded(
                  child: BrainDropdown(
                    onLongPress: (value) {
                      if (value != TimeTable.emptySubject) {
                        NavigationHelper.rootKey.currentState!.pop();
                        NavigationHelper.pushNamed(context, "subjectPage", payload: value);
                      }
                    },
                    dialogTitle: "Wähle ein Fach",
                    defaultText: "Freistunde",
                    currentValue: TimeTable.week[day].subjects[i]?.subject,
                    additionalAction: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppDesign.colors.primary
                      ),
                      child: const Text("Neues Fach"),
                      onPressed: () {
                        NavigationHelper.rootKey.currentState!.pop();
                        
                        NavigationHelper.pushNamed(context, "subjectPage").then((value) {
                          if(value != null) {
                            TimeTable.week[day].subjects[i] = SubjectInstance(value, day+1, i);
                          }
                          SaveSystem.saveTimeTable();
                          BrainApp.notifier.notifyOfChanges();
                        });
                      },
                    ),
                    items: getDropdowns(),
                    onChanged: (value) {
                      if(value == TimeTable.emptySubject) {
                        TimeTable.week[day].subjects[i] = null;
                      } else {
                        TimeTable.week[day].subjects[i] = SubjectInstance(value, day+1, i);
                      }
                      SaveSystem.saveTimeTable();
                      BrainApp.notifier.notifyOfChanges();
                    },
                  ),
                )
              ],
            ),
          )
        );
      }

      tabs.add(
        Column(
          children: entries,
        )
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    int weekDay = DateTime.now().weekday;
    return DefaultTabController(
      initialIndex: weekDay > 5 ? 0 : weekDay - 1,
      length: 5,
      child: PageTemplate(
        title: "Stundenplan",
        backButton: true,
        floatingActionButton: BrainMenuButton(
          defaultAction: () => NavigationHelper.pushNamed(context, "subjectOverview"),
          defaultLabel: "Fächer Bearbeiten",
          icon: Icons.edit,
          withEntries: false,
        ),
        pageSettings: PageSettings(
          floatingHeaderBorderRadius: BorderRadius.circular(100),
          floatingHeaderIsCentered: true
        ),
        floatingHeader: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            minHeight: 55
          ),
          decoration: BoxDecoration(
            color: AppDesign.colors.secondaryBackground,
            borderRadius: BorderRadius.circular(100)
          ),
          clipBehavior: Clip.antiAlias,
          child: Theme(
            data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent
            ),
            child: TabBar(
              labelStyle: AppDesign.textStyles.tab,
              labelColor: AppDesign.colors.contrast,
              unselectedLabelColor: AppDesign.colors.text,
              indicator: BoxDecoration(
                  color: AppDesign.colors.primary,
                  borderRadius: BorderRadius.circular(100)
              ),
              tabs: const [
                Tab(child: Text("Mo")),
                Tab(child: Text("Di")),
                Tab(child: Text("Mi")),
                Tab(child: Text("Do")),
                Tab(child: Text("Fr")),
              ]
            )
          )
        ),
        // TODO: Very dumm aber es geht im moment
        child: SizedBox(
          height: 650,
          child: NotificationListener<OverscrollNotification> (
            onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
            child: TabBarView(
              children: getTimetableTabs()
            )
          )
        )
      )
    );
  }
}
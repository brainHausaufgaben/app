import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

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
        entries.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: 75,
                  child: Center(
                    child: Text(
                      TimeTable.lessonTimes[i].startTime.format(context),
                      style: AppDesign.textStyles.pointElementSecondary
                    ),
                  ),
                ),
                Expanded(
                  child: BrainDropdown(
                    dialogTitle: "Wähle ein Fach",
                    defaultText: "Freistunde",
                    currentValue: TimeTable.week[day].subjects[i]?.subject,
                    additionalAction: TextButton(
                      child: Text("Neues Fach"),
                      onPressed: () {
                        if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
                          NavigationHelper.rootKey.currentState!.pop();
                        }
                        NavigationHelper.pushNamed(context, "subjectPage");
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
            maxWidth: 600
          ),
          decoration: BoxDecoration(
            color: AppDesign.colors.secondaryBackground,
            borderRadius: BorderRadius.circular(100)
          ),
          clipBehavior: Clip.antiAlias,
          child: TabBar(
            labelStyle: AppDesign.textStyles.tab,
            labelColor: AppDesign.colors.contrast,
            unselectedLabelColor: AppDesign.colors.text,
            indicator: BoxDecoration(
              color: AppDesign.colors.primary,
              borderRadius: BorderRadius.circular(100)
            ),
            tabs: const [
              Tab(text: "Mo", height: 55),
              Tab(text: "Di", height: 55),
              Tab(text: "Mi", height: 55),
              Tab(text: "Do", height: 55),
              Tab(text: "Fr", height: 55)
            ],
          ),
        ),
        // TODO: Very dumm aber es geht im moment
        child: SizedBox(
          height: 600,
          child: NotificationListener<OverscrollNotification> (
            onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
            child: TabBarView(
              children: getTimetableTabs(),
            )
          )
        )
      )
    );
  }
}
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Pages/page_template.dart';

import '../main.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePage();
}

class _TimeTablePage extends State<TimeTablePage> with TickerProviderStateMixin {
  List<DropdownMenuItem<Subject>> getDropdowns() {
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
        DropdownMenuItem<Subject>(
          child: PointElement(
            primaryText: subject.name,
            color: subject.color
          ),
          value: subject,
        )
      );
    }
    subjects.add(DropdownMenuItem<Subject>(
      child: PointElement(
          primaryText: TimeTable.emptySubject.name,
          color: TimeTable.emptySubject.color
      ),
      value: TimeTable.emptySubject,
    ));
    subjects.add(DropdownMenuItem<Subject>(
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppDesign.current.primaryColor,
            minimumSize: Size.infinite
          ),
          onPressed: () {
            // Dropdown popup zu machen
            Navigator.pop(context);
            Navigator.of(context).pushNamed("/settings/timetable/subjectPage");
          },
          child: Text("Fach hinzufügen", style: TextStyle(
            color: AppDesign.current.textStyles.contrastColor,
            fontSize: 16
          )),
        ),
      ),
      value: Subject.empty(),
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(TimeTable.lessonTimes[i].startTime.format(context), style: AppDesign.current.textStyles.pointElementSecondary),
                ),
                Expanded(
                  child: CustomDropdown(
                    defaultText: Text("Freistunde", style: AppDesign.current.textStyles.input),
                    currentValue: TimeTable.week[day].subjects[i]?.subject,
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
        ListView(
          padding: EdgeInsets.zero,
          children: entries,
        )
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    int weekDay = DateTime.now().weekday;
    return PageTemplate(
      title: "Stundenplan",
      backButton: true,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          NavigationHelper.pushNamed("/settings/timetable/subjectOverview");
        }
      ),
      child: DefaultTabController(
        initialIndex: weekDay > 5 ? 0 : weekDay - 1,
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                  shape:  RoundedRectangleBorder(
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
                    labelStyle: AppDesign.current.textStyles.tab,
                    labelColor: AppDesign.current.textStyles.contrastColor,
                    unselectedLabelColor: AppDesign.current.textStyles.color,
                    indicator: BoxDecoration(
                        color: AppDesign.current.primaryColor
                    ),
                    tabs: const [
                      Tab(text: "Mo", height: 55),
                      Tab(text: "Di", height: 55),
                      Tab(text: "Mi", height: 55),
                      Tab(text: "Do", height: 55),
                      Tab(text: "Fr", height: 55)
                    ],
                  ),
                )
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TabBarView(
              children: getTimetableTabs(),
            ),
          )
        )
      )
    );
  }
}
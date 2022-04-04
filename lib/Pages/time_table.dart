import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/add_subject.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePage();
}

class _TimeTablePage extends State<TimeTablePage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  List<DropdownMenuItem<Subject>> getDropdowns(){
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
          DropdownMenuItem<Subject>(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: PointElement(
                  primaryText: subject.name,
                  color: subject.color
              ),
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
    return subjects;
  }

  List<Widget> generateTimetableTabs() {
    List<Widget> tabs = [];
    for (int day=0; day<5; day++) {
      List<Widget> entries = [];
      for (int i=0; i<10; i++) {
        String? startTime = TimeTable.getDay(day+1).subjects[i]?.getStartTimeString();
        entries.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
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
                  // TODO: Das ist dumm, man sollte die app irgendwie anders neu laden können
                  TimeTable.app!.setState(() {});
                },
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
      addButtonAction: SubjectPage(),
      child: DefaultTabController(
        initialIndex: weekDay > 5 ? 0 : weekDay - 1,
        length: 5,
        // TODO: Remove the TabBar from the NestedScrollView
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
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
              children: generateTimetableTabs(),
            ),
          )
        )
      )
    );
  }
}
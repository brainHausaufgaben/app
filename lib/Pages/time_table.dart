import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Pages/page_template.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePage();
}

class _TimeTablePage extends State<TimeTablePage> {
  List<DropdownMenuItem<Subject>> getDropdowns(){
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
          DropdownMenuItem<Subject>(
            child: Padding(
              padding: const EdgeInsets.only(top: 17),
              child: PointElement(
                  primaryText: subject.name,
                  color: subject.color
              ),
            ),
            value: subject,
          )
      );
    }
    return subjects;
  }

  List<Widget> generateTimetableTabs() {
    List<Widget> entries = [];
    for (int i=0; i<6; i++) {
      entries.add(
        CustomDropdown(
          defaultText: Text("Frei", style: AppDesign.current.textStyles.input),
          currentValue: TimeTable.subjects[0],
          items: getDropdowns(),
          onChanged: (value) {print("ok");},
        )
      );
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Stundenplan",
      backButton: true,
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
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
                  Tab(text: "M", height: 55),
                  Tab(text: "D", height: 55),
                  Tab(text: "M", height: 55),
                  Tab(text: "D", height: 55),
                  Tab(text: "F", height: 55)
                ],
              ),
            ),
            SizedBox(
              height: 700,
              child: TabBarView(
                children: [
                  Wrap(
                    runSpacing: 10,
                    children: generateTimetableTabs(),
                  ),
                  Text("ok"),
                  Text("ok"),
                  Text("ok"),
                  Text("ok")
                ],
              )
            )
          ]
        ),
      ),
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import '../Backend/subject.dart';
import '../Components/collapsible_grades_box.dart';
import 'page_template.dart';

class GradeOverview extends StatefulWidget {
  const GradeOverview({Key? key}): super(key: key);

  @override
  State<GradeOverview> createState() => _GradeOverview();
}

class _GradeOverview extends State<GradeOverview>{
  bool collapsed = false;

  List<Widget> getGradeButtons() {
    List<Widget> buttons = [];

    for (Subject subject in TimeTable.subjects) {
      buttons.add(
        CustomIconButton(
          dense: true,
          child: PointElement(
            color: subject.color,
            primaryText: subject.name,
            child: Text("${GradingSystem.getAverage(subject)} Punkte", style: AppDesign.current.textStyles.pointElementSecondary),
          ),
          icon: Icons.edit,
          action: () {},
        )
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: 'Noten',
        floatingActionButton: CustomMenuButton(
            defaultAction: () => NavigationHelper.pushNamed("/gradesPage")
        ),
        child: Column(
          children: [
            CollapsibleGradesBox(
              collapsed: collapsed,
              onTap: () => setState(() => collapsed = !collapsed),
            ),
            Expanded(
              child: ListView(
                children: [
                  HeadlineWrap(
                    headline: "Alle Noten",
                    children: getGradeButtons(),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
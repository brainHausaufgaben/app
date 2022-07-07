import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import '../../Backend/subject.dart';
import '../../Components/grades_box.dart';
import '../../main.dart';
import '../page_template.dart';

class GradeOverview extends StatefulWidget {
  const GradeOverview({Key? key}): super(key: key);

  @override
  State<GradeOverview> createState() => _GradeOverview();
}

class _GradeOverview extends State<GradeOverview>{
  List<Widget> getGradeButtons() {
    List<Widget> buttons = [];

    for (Subject subject in TimeTable.subjects) {
      double average = GradingSystem.getAverage(subject);
      buttons.add(
        CustomIconButton(
          dense: true,
          child: PointElement(
            color: subject.color,
            primaryText: subject.name,
            child: Text(average == -1.0 ? "Noch keine Noten" : "${average.toInt()} Punkte", style: AppDesign.current.textStyles.pointElementSecondary),
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
            CollapsibleGradesBox(),
            Expanded(
              child: ScrollShadow(
                color: AppDesign.current.themeData.scaffoldBackgroundColor.withOpacity(0.8),
                curve: Curves.ease,
                size: 15,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                  children: [
                    HeadlineWrap(
                      headline: "Alle Noten",
                      children: getGradeButtons(),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/custom_inputs.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/subject_page.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

class SubjectOverview extends StatefulWidget {
  const SubjectOverview({Key? key}) : super(key: key);

  @override
  State<SubjectOverview> createState() => _SubjectOverview();
}

class _SubjectOverview extends State<SubjectOverview> {
  List<CustomIconButton> getSubjectButtons() {
    List<CustomIconButton> buttons = [];
    for (Subject subject in TimeTable.subjects) {
      buttons.add(CustomIconButton(
        child: PointElement(
          primaryText: subject.name,
          color: subject.color,
        ),
        icon: Icons.edit,
        dense: true,
        action: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubjectPage(previousSubject: subject))
          );
        },
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Alle Fächer",
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubjectPage())
        )
      ),
      child: ScrollShadow(
        color: AppDesign.current.themeData.scaffoldBackgroundColor.withOpacity(0.8),
        curve: Curves.ease,
        size: 15,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            runSpacing: 5,
            children: getSubjectButtons(),
          ),
        ),
      ),
      backButton: true,
    );
  }
}
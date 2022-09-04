import 'dart:collection';

import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/grades_box.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum SortMethods {
  bySubject,
  byGrade,
  bySemester
}

class GradeOverview extends StatefulWidget {
  const GradeOverview({Key? key}): super(key: key);

  static bool sortAscending = false;
  static SortMethods? sortMethod;
  static ValueNotifier<TimeSelectors> timeSelectors = ValueNotifier(TimeSelectors.thisYear);

  @override
  State<GradeOverview> createState() => _GradeOverview();
}

class _GradeOverview extends State<GradeOverview>{
  List<int> get partsOfYear => GradeOverview.timeSelectors.value == TimeSelectors.thisYear ? [1, 2, 3] : [GradeOverview.timeSelectors.value.index];
  late Function() listener;

  LinkedHashMap sortByValue(Map map) {
    List sortedKeys = map.keys.toList(growable: false)..sort((key1, key2) {
      return GradeOverview.sortAscending
          ? map[key1]!.compareTo(map[key2]!)
          : map[key2]!.compareTo(map[key1]!);
    });

    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => map[k]!
    );

    return sortedMap;
  }

  LinkedHashMap sortByKey(Map<Subject, double> map) {
    List sortedKeys = map.keys.toList(growable: false)..sort((key1, key2) {
      return GradeOverview.sortAscending
          ? key1.name.compareTo(key2.name)
          : key2.name.compareTo(key1.name);
    });

    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => map[k]!
    );

    return sortedMap;
  }

  List<Widget> getGradeButtons() {
    Map<Subject, double> subjectPairs = {};

    List<Widget> buttons = [];

    for (Subject subject in TimeTable.subjects) {
      double average = GradingSystem.getAverage(subject, onlyPartsOfYear: partsOfYear);
      subjectPairs[subject] = average;
    }

    LinkedHashMap sortedMap;

    switch(GradeOverview.sortMethod) {
      case SortMethods.bySubject:
        sortedMap = sortByKey(subjectPairs);
        break;
      case SortMethods.byGrade:
        sortedMap = sortByValue(subjectPairs);
        break;
      default:
        sortedMap = LinkedHashMap.of(subjectPairs);
    }

    sortedMap.forEach((key, value) {
      buttons.add(
        BrainIconButton(
          dense: true,
          child: PointElement(
            color: key.color,
            primaryText: key.name,
            child: Text(
              value == -1.0
                  ? "Noch keine Noten"
                  : GradingSystem.isAdvancedLevel
                      ? "${value.toInt()} Punkt${value.toInt() == 1 ? "" : "e"}"
                      : "Note ${value.toString()}",
              style: AppDesign.textStyles.pointElementSecondary),
          ),
          icon: Icons.edit,
          action: () => NavigationHelper.pushNamed(context, "gradesPerSubject", payload: key),
        )
      );
    });

    return buttons;
  }

  @override
  void initState() {
    listener = () => setState(() {});
    GradeOverview.timeSelectors.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    GradeOverview.timeSelectors.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.velocity.pixelsPerSecond.dx < 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 1;
            NavigationHelper.pushNamedReplacement(context, "home");
          }
        }
      },
      child: PageTemplate(
          title: 'Noten',
          floatingActionButton: BrainMenuButton(
            defaultAction: () => NavigationHelper.pushNamed(context, "gradesPage"),
            defaultLabel: "Neu",
          ),
          floatingHeader: Wrap(
            runSpacing: 10,
            children: [
              GradesBox(
                value: GradingSystem.getYearAverage(onlyPartsOfYear: partsOfYear).toStringAsFixed(2),
                currentSelector: GradeOverview.timeSelectors.value,
                onChanged: (value) {
                  GradeOverview.timeSelectors.value = value;
                },
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: BrainDropdown(
                        dialogTitle: "Sortieren nach...",
                        scrollableDialog: false,
                        defaultText: "Sortieren nach...",
                        currentValue: GradeOverview.sortMethod,
                        items: [
                          BrainDropdownEntry(
                              value: SortMethods.bySubject,
                              child: Text("Fach", style: AppDesign.textStyles.input)
                          ),
                          BrainDropdownEntry(
                              value: SortMethods.byGrade,
                              child: Text("Note", style: AppDesign.textStyles.input)
                          )
                        ],
                        onChanged: (value) {
                          if (GradeOverview.sortMethod != value) setState(() => GradeOverview.sortMethod = value);
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Semantics(
                      container: true,
                      button: true,
                      excludeSemantics: true,
                      label: "Tippe um aufsteigend zu sortieren",
                      child: TextButton(
                          onPressed: () {
                            if (!GradeOverview.sortAscending) setState(() => GradeOverview.sortAscending = true);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: GradeOverview.sortAscending ? AppDesign.colors.primary : AppDesign.colors.secondaryBackground,
                              primary: GradeOverview.sortAscending ? AppDesign.colors.secondaryBackground : AppDesign.colors.primary,
                              padding: const EdgeInsets.all(14),
                              minimumSize: Size.zero
                          ),
                          child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: GradeOverview.sortAscending ? AppDesign.colors.contrast : AppDesign.colors.text
                          )
                      ),
                    ),
                  ),
                  Semantics(
                    container: true,
                    button: true,
                    excludeSemantics: true,
                    label: "Tippe um absteigend zu sortieren",
                    child: TextButton(
                        onPressed: () {
                          if (GradeOverview.sortAscending) setState(() => GradeOverview.sortAscending = false);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: GradeOverview.sortAscending ? AppDesign.colors.secondaryBackground : AppDesign.colors.primary,
                            primary: GradeOverview.sortAscending ? AppDesign.colors.primary : AppDesign.colors.secondaryBackground,
                            padding: const EdgeInsets.all(14),
                            minimumSize: Size.zero
                        ),
                        child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: GradeOverview.sortAscending ? AppDesign.colors.text : AppDesign.colors.contrast
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
          child: TimeTable.subjects.isEmpty
              ? Container()
              : HeadlineWrap(
              headline: "Alle Fächer",
              children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 300),
                  childAnimationBuilder: (child) => SlideAnimation(
                    key: GlobalKey(),
                      verticalOffset: 30.0,
                      child: FadeInAnimation(
                        child: child,
                      )
                  ),
                  children: getGradeButtons()
              )
          )
      )
    );
  }
}
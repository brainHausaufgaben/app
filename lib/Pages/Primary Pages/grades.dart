import 'dart:collection';

import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/headline_wrap.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:flutter/material.dart';

enum SortMethods {
  bySubject,
  byGrade
}

class GradeOverview extends StatefulWidget {
  GradeOverview({Key? key}): super(key: key);

  bool sortAscending = false;
  SortMethods? sortMethod;

  @override
  State<GradeOverview> createState() => _GradeOverview();
}

class _GradeOverview extends State<GradeOverview>{
  LinkedHashMap sortByValue(Map map) {
    List sortedKeys = map.keys.toList(growable: false)..sort((key1, key2) {
      return widget.sortAscending
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
      return widget.sortAscending
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
      double average = GradingSystem.getAverage(subject);
      subjectPairs[subject] = average;
    }

    LinkedHashMap sortedMap;

    switch(widget.sortMethod) {
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
            child: Text(value == -1.0 ? "Noch keine Noten" : "${value.toInt()} Punkte", style: AppDesign.current.textStyles.pointElementSecondary),
          ),
          icon: Icons.edit,
          action: () => NavigationHelper.pushNamed(context, "gradesPerSubject", payload: key),
        )
      );
    });

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.primaryVelocity! < 0.0) {
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
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15
                ),
                decoration: BoxDecoration(
                    color: AppDesign.current.primaryColor,
                    borderRadius: AppDesign.current.boxStyle.borderRadius
                ),
                child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      GradeWidget(
                        name: GradingSystem.getYearAverage().round() == 1 ? "Punkt" : "Punkte",
                        value: (){
                          if(GradingSystem.getYearAverage() == -1) {
                            return "-";
                          } else {
                            return GradingSystem.getYearAverage().round().toString();
                          }
                        }(),
                        reversed: false,
                      ),
                      const Spacer(flex: 1),
                      GradeWidget(
                        name: "Note",
                        value: GradingSystem.PointToGrade(GradingSystem.getYearAverage().round()),
                        reversed: true,
                      )
                    ]
                )
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: BrainDropdown(
                        dialogTitle: "Sortieren nach...",
                        scrollableDialog: false,
                        defaultText: "Sortieren nach...",
                        currentValue: widget.sortMethod,
                        items: [
                          BrainDropdownEntry(
                              value: SortMethods.bySubject,
                              child: Text("Fach", style: AppDesign.current.textStyles.input)
                          ),
                          BrainDropdownEntry(
                              value: SortMethods.byGrade,
                              child: Text("Note", style: AppDesign.current.textStyles.input)
                          )
                        ],
                        onChanged: (value) {
                          setState(() => widget.sortMethod = value);
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                        onPressed: () {
                          setState(() => widget.sortAscending = true);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: widget.sortAscending ? AppDesign.current.primaryColor : AppDesign.current.boxStyle.backgroundColor,
                            primary: widget.sortAscending ? AppDesign.current.boxStyle.backgroundColor : AppDesign.current.primaryColor,
                            padding: EdgeInsets.all(14),
                            minimumSize: Size.zero
                        ),
                        child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: widget.sortAscending ? AppDesign.current.textStyles.contrastColor : AppDesign.current.textStyles.color
                        )
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() => widget.sortAscending = false);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: widget.sortAscending ? AppDesign.current.boxStyle.backgroundColor : AppDesign.current.primaryColor,
                          primary: widget.sortAscending ? AppDesign.current.primaryColor : AppDesign.current.boxStyle.backgroundColor,
                          padding: EdgeInsets.all(14),
                          minimumSize: Size.zero
                      ),
                      child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: widget.sortAscending ? AppDesign.current.textStyles.color : AppDesign.current.textStyles.contrastColor
                      )
                  ),
                ],
              )
            ],
          ),
          child: TimeTable.subjects.isEmpty
              ? Container()
              : Column(
            children: [
              HeadlineWrap(
                  headline: "Alle Fächer",
                  children: getGradeButtons()
              )
            ],
          )
      )
    );
  }
}

class GradeWidget extends StatelessWidget {
  GradeWidget({
    Key? key,
    required this.name,
    required this.value,
    required this.reversed
  }) : super(key: key);

  final String name;
  final String value;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 8,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: AppDesign.current.boxStyle.borderRadius,
                color: AppDesign.current.boxStyle.backgroundColor
            ),
            child: Center(
                child: Wrap(
                    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                          value,
                          style: TextStyle(
                              color: AppDesign.current.textStyles.color,
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          )
                      ),
                      Text(
                          name,
                          style: TextStyle(
                              color: AppDesign.current.textStyles.color,
                              fontSize: 17,
                              fontWeight: FontWeight.w700
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}
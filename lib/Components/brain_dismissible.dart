import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/material.dart';

import 'brain_toast.dart';

class BrainDismissible extends StatelessWidget {
  const BrainDismissible({Key? key, required this.homework}) : super(key: key);

  final Homework homework;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Dismissible(
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              TimeTable.removeHomework(homework);
              BrainVibrations.successVibrate();
              BrainToast toast = BrainToast(
                text: "Hausaufgabe gelöscht!",
                buttonText: "Rückgängig",
                action: () {
                  TimeTable.reinstateLastHomework();
                  BrainToast.close();
                }
              );
              toast.show();

              return true;
            } else if (direction == DismissDirection.endToStart) {

              NavigationHelper.pushNamed(context, "homework", payload: homework);
              return false;
            }

            return true;
          },
          secondaryBackground: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow,
              ),
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.edit, color: Colors.black)
                ),
              )
          ),
          background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.check_circle, color: Colors.white)
                ),
              )
          ),
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppDesign.colors.background,
                    boxShadow: [
                      AppDesign.boxStyle.boxShadow
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(homework.name, style: AppDesign.textStyles.pointElementSecondary),
                )
              )
            ]
          )
        )
    );
  }
}
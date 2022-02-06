import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/material.dart';

class DismissableBox extends StatelessWidget {
   DismissableBox({Key? key,required this.homework}) : super(key: key);
  Homework homework;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Dismissible(
          onDismissed: (DismissDirection){
            TimeTable.removeHomework(homework);
          },
            secondaryBackground: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.yellow,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Align(
                      child: Icon(Icons.access_time, color: Colors.black),
                      alignment: Alignment.centerRight
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
                      child: Icon(Icons.check_circle, color: Colors.white),
                      alignment: Alignment.centerLeft
                  ),
                )
            ),
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            child: Container(
              constraints: const BoxConstraints.expand(height: 40), // Temporärer fix weil sonst nicht ganze breite
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppDesign.current.boxStyle.backgroundColor,
                  boxShadow: [
                    AppDesign.current.boxStyle.boxShadow
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(homework.name, style: AppDesign.current.textStyles.pointElementSecondary),
              ),
            )
        ),
    );
  }
}
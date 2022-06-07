import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Pages/homework_page.dart';
import 'package:flutter/material.dart';

class DismissableBox extends StatelessWidget {
  const DismissableBox({Key? key,required this.homework}) : super(key: key);

  final Homework homework;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Dismissible(
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              TimeTable.removeHomework(homework);
            } else if (direction == DismissDirection.endToStart) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeworkPage(previousHomework: homework))
              );
              return false;
            }
          },
          secondaryBackground: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow,
              ),
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Align(
                    child: Icon(Icons.edit, color: Colors.black),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
            ],
          )
        ),
    );
  }
}
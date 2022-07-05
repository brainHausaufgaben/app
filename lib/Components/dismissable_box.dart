import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/homework_page.dart';
import 'package:brain_app/main.dart';
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

              SnackBar snackBar = SnackBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                dismissDirection: DismissDirection.horizontal,
                backgroundColor: BrainApp.preferences["darkMode"] ? const Color(0xFFFFFFFF) : const Color(0xFF303540),
                duration: const Duration(seconds: 6),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text("Hausaufgabe gelöscht", style: TextStyle(
                          color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 15
                      )),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF),
                          width: 1.5
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        child: Text(
                            "Rückgängig",
                            style: TextStyle(
                                color: BrainApp.preferences["darkMode"] ? const Color(0xFF303540) : const Color(0xFFFFFFFF))
                        ),
                      ),
                      onPressed: () {
                        TimeTable.reinstateLastHomework();
                        ScaffoldMessenger.of(NavigationHelper.context).hideCurrentSnackBar();
                      },
                    )
                  ],
                )
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              return true;
            } else if (direction == DismissDirection.endToStart) {
              NavigationHelper.navigator.push(
                  MaterialPageRoute(builder: (context) => HomeworkPage(previousHomework: homework))
              );
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
                    color: AppDesign.current.themeData.scaffoldBackgroundColor,
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
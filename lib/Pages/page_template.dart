import 'package:brain_app/Pages/add_homework.dart';
import 'package:brain_app/Pages/time_table.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({Key? key, required this.title, required this.child, this.backButton, this.addButtonAction}) : super(key: key);
  final Widget child;
  final String title;
  final bool? backButton;
  final Widget? addButtonAction;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  void _settings(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeTablePage())
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  String getDateString(DateTime date){

    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];

    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();

    String weekDay =  weekDays[date.weekday - 1];

    return weekDay + ", " + day + "." + month + "." + year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: MediaQuery.of(context).viewPadding.top + 10, right: 15),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Settings Button / oder back button °o°
                IconButton(
                  alignment: Alignment.centerLeft,
                  // Idk
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(0),
                  onPressed: widget.backButton == null ? _settings : _back,
                  icon: Icon(widget.backButton == null ? Icons.settings_rounded : Icons.keyboard_return, color: AppDesign.current.textStyles.color),
                  iconSize: 26,
                  splashRadius: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text(
                        widget.title,
                        style: AppDesign.current.textStyles.pageHeadline,
                      ),
                      Text(
                        getDateString(DateTime.now()),
                        style: AppDesign.current.textStyles.pageSubtitle,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: widget.child
            )
          ],
        )
      ),
      floatingActionButton: widget.addButtonAction == null ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.addButtonAction!)
          );
        },
        tooltip: 'Hausaufgabe',
        child: const Icon(Icons.add),
      ),
    );
  }
}
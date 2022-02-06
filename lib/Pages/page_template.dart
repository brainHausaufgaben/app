import 'package:brain_app/Pages/homework.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({Key? key, required this.title, required this.child, this.backButton}) : super(key: key);
  final Widget child;
  final String title;
  final bool? backButton;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  void _settings(){
    AppDesign.darkMode = !AppDesign.darkMode;
    currentDesign.toggleTheme(Designs.monochromeTheme);
    print("settngs");
  }

  void _back() {
    Navigator.pop(context);
  }

  String getDateString(){

    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];

    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();

    String weekDay =  weekDays[DateTime.now().weekday - 1];

    return weekDay + ", " + day + "." + month + "." + year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: MediaQuery.of(context).viewPadding.top + 10, right: 15),
        child:Column(
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
                    getDateString(),
                    style: AppDesign.current.textStyles.pageSubtitle,
                  )
                ],
              ),
            ),
            widget.child
          ],
        ),
      ),
      floatingActionButton: widget.backButton != null ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeworkPage())
          );
        },
        tooltip: 'Hausaufgabe',
        child: const Icon(Icons.add),
      ),
    );
  }
}
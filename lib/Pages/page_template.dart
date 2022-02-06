import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({Key? key, required this.title, required this.child}) : super(key: key);
  final Widget child;
  final String title;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  void _settings(){
    print("settngs");
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
            //Settings Button
            IconButton(
              alignment: Alignment.centerLeft,
              // Der dumme button braucht constraints weil er sonst viel zu groß wird aber jetzt scheint er keine collision mehr zu haben
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all( 0),
              onPressed: _settings,
              icon: Icon(Icons.settings_rounded, color: AppDesign.current.textStyles.color),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppDesign.darkMode = !AppDesign.darkMode;
          currentDesign.toggleTheme(Designs.monochromeTheme);
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
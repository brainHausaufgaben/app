import 'package:flutter/material.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({Key? key, required this.title, required this.child}) : super(key: key);
  final Widget child;
  final String title;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
              icon: const Icon(Icons.settings_rounded),
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
                    style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800, fontSize:38, height: 0.6),
                  ),
                  Text(
                    getDateString(),
                    style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w400, fontSize:20),
                  )
                ],
              ),
            ),
            widget.child
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
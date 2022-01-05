import 'package:flutter/material.dart';
import 'warning_box.dart';

// Ich versteh nicht wie ich da ein widget rein geb und das unten anfüge also ist das fürs erste nicht so
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        padding: const EdgeInsets.only(left: 15, top: 40, right: 15, bottom: 25),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Settings Button
            IconButton(
              alignment: Alignment.centerLeft,
              // Der dumme button braucht constraints weil er sonst viel zu groß wird aber jetzt scheint er keine collision mehr zu haben
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(bottom: 15),
              onPressed: _settings,
              icon: Image.asset( 'icons/settingsButtonIcon.png'),
              iconSize: 26,
              splashRadius: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  const Text(
                    "Übersicht",
                    style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w800,fontSize:38, height: 0.6 ),
                  ),
                  Text(
                    getDateString(),
                    style: const TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w400,fontSize:20 ),
                  )
                ],
              ),
            ),
            const WarningBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
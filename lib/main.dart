import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Hausaufgabenheft',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Brain App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              padding: const EdgeInsets.only(bottom: 40),
              onPressed: _settings,
              icon: Image.asset( 'icons/settingsButtonIcon.png'),
              iconSize: 26,
              splashRadius: 1,
            ),
            const Padding(
                padding: EdgeInsets.only(left: 0,bottom: 0,top: 22,right: 0),
                child: Text(
                  "Übersicht",
                  style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w800,fontSize:38, height: 0.6 ),
              ),
            ),
            Text(
              getDateString(),
              style: const TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w400,fontSize:20 ),
            )
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

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Settings Button
          IconButton(
            onPressed: _settings,
            icon: Image.asset( 'icons/settingsButtonIcon.png'),
            iconSize: 25,
            splashRadius: 10,
          ),

          const Text(
            "Übersicht",
            style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w800,fontSize:40 ),
            

          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

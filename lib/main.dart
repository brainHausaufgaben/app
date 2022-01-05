import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'page_template.dart';
import 'utilities.dart';

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
        primarySwatch: createMaterialColor(AppTheme.mainColor),
      ),
      home: const HomePage(title: 'Brain App'),
    );
  }
}

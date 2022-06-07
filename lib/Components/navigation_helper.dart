import 'package:brain_app/Pages/calendar_page.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/Pages/home_page.dart';
import 'package:brain_app/Pages/settings_page.dart';
import 'package:brain_app/Components/custom_navigation_bar.dart';

class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  @override
  _NavigationHelper createState() => _NavigationHelper();
}

class _NavigationHelper extends State<NavigationHelper> {
  int selectedIndex = 0;

  Widget getCorrespondingPage(int index) {
    switch(index) {
      case 1:
        return HomePage();
        break;
      case 2:
        return CalendarPage();
        break;
    }
    return HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCorrespondingPage(selectedIndex),
      bottomNavigationBar: CustomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        }
      ),
    );
  }
}
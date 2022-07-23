import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/add_edit_grades.dart';
import 'package:brain_app/Pages/add_homework.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

class CustomQuickActions extends StatefulWidget {
  final Widget child;
  const CustomQuickActions({ Key? key, required this.child}) : super(key: key);


  @override
  _QuickActionsManagerState createState() => _QuickActionsManagerState();
}

class _QuickActionsManagerState extends State<CustomQuickActions> {
  final QuickActions quickActions = const QuickActions();

  @override
  void initState(){
    super.initState();
    _setupQuickActions();
    _handleQuickActions();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _setupQuickActions() {
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'add_homework',
          localizedTitle: 'Hausaufgabe Hinzufügen',
          icon: ""),
       ShortcutItem(
          type: 'add_grade',
          localizedTitle: 'Note Hinzufügen',
          icon:Icons.ac_unit.toString()),
    ]);
  }

  void _handleQuickActions() {
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'add_homework') {
        NavigationHelper.push(HomeworkPage());
      } else if(shortcutType == 'action_help') {
        NavigationHelper.push(GradesPage());
      }
    });
  }


}
import 'package:brain_app/Components/navigation_helper.dart';
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
          icon: "add_homework"
      ),
      const ShortcutItem(
          type: 'add_grade',
          localizedTitle: 'Note Hinzufügen',
          icon: 'add_grade'
       ),
      const ShortcutItem(
          type: 'add_event',
          localizedTitle: 'Termin Hinzufügen',
          icon: ""
      ),
    ]);
  }

  void _handleQuickActions() {
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'add_homework') {
        NavigationHelper.pushNamed(context, "homework");
      } else if (shortcutType == 'add_event') {
        NavigationHelper.pushNamed(context, "addEventPage");
      }
      else if (shortcutType == 'add_grade') {
        NavigationHelper.pushNamed(context, "gradesPage");
      }
    });
  }


}
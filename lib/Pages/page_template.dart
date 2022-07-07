import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({
    Key? key,
    required this.title,
    required this.child,
    this.backButton, this.subtitle,
    this.floatingActionButton,
    this.floatingActionButtonLocation
  }) : super(key: key);

  final Widget child;
  final String title;
  final String? subtitle;
  final bool? backButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  void _settings(){
    NavigationHelper.pushNamed("/settings");
  }

  void _back() {
    Navigator.pop(context);
  }

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];

    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();

    String weekDay =  weekDays[date.weekday - 1];

    return weekDay + ", " + day + "." + month + "." + year;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onHorizontalDragEnd: (details) {
        // TODO: es soll page switchen wenn man auf den drei hauptseiten ist
      },
      child: Scaffold (
          body: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  top: MediaQuery.of(context).viewPadding.top + 10,
                  right: 15
              ),
              child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            alignment: Alignment.centerLeft,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(0),
                            onPressed: widget.backButton == null ? _settings : _back,
                            icon: Icon(widget.backButton == null ? Icons.settings_rounded : Icons.keyboard_return, color: AppDesign.current.textStyles.color),
                            iconSize: 26,
                            splashRadius: 15,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> [
                                    Text(
                                      widget.title,
                                      style: AppDesign.current.textStyles.pageHeadline,
                                    ),
                                    Text(
                                      widget.subtitle ?? getDateString(DateTime.now()),
                                      style: AppDesign.current.textStyles.pageSubtitle,
                                    )
                                  ]
                              )
                          )
                        ]
                    ),
                    Flexible(
                        child: widget.child
                    )
                  ]
              )
          ),
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButton: widget.floatingActionButton
      )
    );
  }
}
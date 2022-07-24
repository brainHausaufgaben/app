import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate({
    Key? key,
    required this.title,
    required this.child,
    this.floatingHeader,
    this.backButton, this.subtitle,
    this.floatingActionButton,
    this.floatingActionButtonLocation
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? floatingHeader;
  final String? subtitle;
  final bool? backButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  void _settings(){
    NavigationHelper.pushNamed(context, "settings");
  }

  void _back() {
    Navigator.of(context).pop();
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
      child: Scaffold (
          body: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  top: MediaQuery.of(context).viewPadding.top,
                  right: 15
              ),
              child: ScrollShadow(
                color: AppDesign.current.themeData.scaffoldBackgroundColor.withOpacity(0.8),
                curve: Curves.ease,
                size: 15,
                child: ListView (
                   shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    children: [
                      Align(
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          onPressed: widget.backButton == null ? _settings : _back,
                          icon: Icon(widget.backButton == null ? Icons.settings_rounded : Icons.keyboard_backspace, color: AppDesign.current.textStyles.color),
                          iconSize: 26,
                          splashRadius: 15,
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 30, bottom: widget.floatingHeader != null ? 15 : 25),
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
                      ),
                      if (widget.floatingHeader != null)
                        StickyHeader(
                          content: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: widget.child,
                          ),
                          header: Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppDesign.current.themeData.scaffoldBackgroundColor,
                                  blurRadius: 10,
                                  spreadRadius: 8
                                )
                              ]
                            ),
                            child: widget.floatingHeader!,
                          )
                        )
                      else
                        widget.child
                    ]
                ),
              )
          ),
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButton: widget.floatingActionButton
      )
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/developer_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class PageSettings {
  const PageSettings({
    this.floatingActionButtonLocation,
    this.floatingHeaderBorderRadius,
    this.floatingHeaderIsCentered = false,
    this.developerOptions = false,
  });

  final BorderRadius? floatingHeaderBorderRadius;
  final bool floatingHeaderIsCentered;
  final bool developerOptions;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
}

class PageTemplate extends StatefulWidget {
  const PageTemplate({
    Key? key,
    required this.title,
    required this.child,
    this.floatingHeader,
    this.backButton = false,
    this.subtitle,
    this.floatingActionButton,
    this.pageSettings = const PageSettings()
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? floatingHeader;
  final String? subtitle;
  final bool backButton;
  final Widget? floatingActionButton;
  final PageSettings pageSettings;

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

  Widget getFloatingHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: widget.pageSettings.floatingHeaderBorderRadius,
          boxShadow: [
            BoxShadow(
                color: AppDesign.current.themeData.scaffoldBackgroundColor,
                blurRadius: 10,
                spreadRadius: 8
            )
          ]
      ),
      child: widget.floatingHeader!,
    );
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
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                backgroundColor: AppDesign.current.boxStyle.backgroundColor,
                                minimumSize: Size.zero
                            ),
                            onPressed: widget.backButton ? _back : _settings,
                            child: Icon(widget.backButton ? Icons.keyboard_backspace : Icons.settings_rounded, color: AppDesign.current.textStyles.color),
                          )
                        ]
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 25, bottom: widget.floatingHeader != null ? 20 : 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Text(
                                  widget.title,
                                  style: AppDesign.current.textStyles.pageHeadline,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3, left: 5),
                                  padding: const EdgeInsets.only(left: 6, top: 3, bottom: 1),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: AppDesign.current.textStyles.pageSubtitle.color!, width: 2)
                                    )
                                  ),
                                  child: GestureDetector(
                                    onTap: widget.pageSettings.developerOptions ? () {
                                      if (DateTime.now().difference(DeveloperOptionsPage.lastClick).inSeconds < 2) {
                                        DeveloperOptionsPage.timesClicked++;
                                      } else {
                                        DeveloperOptionsPage.timesClicked = 0;
                                      }
                                      DeveloperOptionsPage.lastClick = DateTime.now();

                                      if (DeveloperOptionsPage.timesClicked == 10) NavigationHelper.pushNamed(context, "developerOptions");
                                    } : null,
                                    child: MouseRegion(
                                      cursor: widget.pageSettings.developerOptions ? SystemMouseCursors.click : SystemMouseCursors.basic,
                                      child: Text(
                                        widget.subtitle ?? getDateString(DateTime.now()),
                                        style: AppDesign.current.textStyles.pageSubtitle,
                                      ),
                                    )
                                  )
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
                          header: widget.pageSettings.floatingHeaderIsCentered
                              ? Center(child: getFloatingHeader())
                              : getFloatingHeader()
                        )
                      else
                        widget.child
                    ]
                )
              )
          ),
          floatingActionButtonLocation: widget.pageSettings.floatingActionButtonLocation,
          floatingActionButton: widget.floatingActionButton
      )
    );
  }
}
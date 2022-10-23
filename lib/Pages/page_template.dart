import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/developer_options.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class PageSettings {
  const PageSettings({
    this.floatingActionButtonLocation,
    this.floatingHeaderBorderRadius,
    this.floatingHeaderIsCentered = false,
    this.developerOptions = false,
    this.bottomPadding = 0
  });

  final BorderRadius? floatingHeaderBorderRadius;
  final bool floatingHeaderIsCentered;
  final bool developerOptions;
  final double bottomPadding;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
}

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    Key? key,
    required this.title,
    required this.body,
    this.floatingHeader,
    this.secondaryPage = false,
    this.subtitle,
    this.floatingActionButton,
    this.secondaryTitleButton,
    this.pageSettings = const PageSettings()
  }) : super(key: key);

  final String title;
  final Widget body;
  final Widget? floatingHeader;
  final String? subtitle;
  final bool secondaryPage;
  final Widget? floatingActionButton;
  final PageSettings pageSettings;
  final Widget? secondaryTitleButton;


  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];

    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();

    String weekDay =  weekDays[date.weekday - 1];

    return "$weekDay, $day.$month.$year";
  }

  Widget getFloatingHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: pageSettings.floatingHeaderBorderRadius,
          boxShadow: [
            AppDesign.boxStyle.boxShadow
          ]
      ),
      child: floatingHeader!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold (
            backgroundColor: AppDesign.colors.background,
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ScrollShadow(
                        color: AppDesign.colors.background.withOpacity(0.8),
                        curve: Curves.ease,
                        size: 15,
                        child: ListView(
                            padding: EdgeInsets.only(top: 10, bottom: 25 + pageSettings.bottomPadding),
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BrainTitleButton(
                                        icon: secondaryPage ? Icons.keyboard_backspace : Icons.settings_rounded,
                                        semantics: secondaryPage ? "Zurück" : "Einstellungen",
                                        action: secondaryPage
                                            ? () {
                                              Navigator.of(context).maybePop().then((didPop) {
                                                if (!didPop) {
                                                  NavigationHelper.pushNamedReplacement(context, "/");
                                                  BrainToast toast = const BrainToast(text: "Du wurdest auf die Homepage geschickt, da die vorherigen Seiten nicht zu existieren scheinen");
                                                  toast.show();
                                                }
                                              });
                                            } : () => NavigationHelper.pushNamed(context, "settings")
                                    ),
                                    if (secondaryTitleButton != null) secondaryTitleButton!
                                  ]
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 30, bottom: floatingHeader != null ? 20 : 30),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: AppDesign.textStyles.pageHeadline,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(top: 3, left: 5),
                                            padding: const EdgeInsets.only(left: 6, top: 3, bottom: 1),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(color: AppDesign.colors.text08, width: 2)
                                                )
                                            ),
                                            child: GestureDetector(
                                                onTap: pageSettings.developerOptions ? () {
                                                  if (DateTime.now().difference(DeveloperOptionsPage.lastClick).inSeconds < 2) {
                                                    DeveloperOptionsPage.timesClicked++;
                                                  } else {
                                                    DeveloperOptionsPage.timesClicked = 0;
                                                  }
                                                  DeveloperOptionsPage.lastClick = DateTime.now();

                                                  if (DeveloperOptionsPage.timesClicked == 10) {
                                                    BrainApp.updatePreference("showDeveloperOptions", true);
                                                    NavigationHelper.pushNamed(context, "developerOptions");
                                                    BrainApp.notifier.notifyOfChanges();
                                                  }
                                                } : null,
                                                child: MouseRegion(
                                                  cursor: pageSettings.developerOptions ? SystemMouseCursors.click : SystemMouseCursors.basic,
                                                  child: Text(
                                                    subtitle ?? getDateString(DateTime.now()),
                                                    style: AppDesign.textStyles.pageSubtitle,
                                                  ),
                                                )
                                            )
                                        )
                                      ]
                                  )
                              ),
                              if (floatingHeader != null && BrainApp.preferences["pinnedHeader"])
                                StickyHeader(
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: body,
                                    ),
                                    header: pageSettings.floatingHeaderIsCentered
                                        ? Center(child: getFloatingHeader())
                                        : getFloatingHeader()
                                )
                              else
                                Column(
                                    crossAxisAlignment: pageSettings.floatingHeaderIsCentered
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (floatingHeader != null && !BrainApp.preferences["pinnedHeader"]) Padding(
                                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                                        child: floatingHeader!,
                                      ),
                                      body
                                    ]
                                )
                            ]
                        )
                    )
                )
            ),
            floatingActionButtonLocation: pageSettings.floatingActionButtonLocation,
            floatingActionButton: floatingActionButton
        )
    );
  }
}
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/initializer.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/box.dart';
import 'package:brain_app/Components/brain_confirmation_dialog.dart';
import 'package:brain_app/Components/brain_infobox.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/home_page_day.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/Primary%20Pages/calendar.dart';
import 'package:brain_app/Pages/page_template.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  static int timesRun = 0;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  List<int> getDayIndices(){
    List<int> dayIndices =  [];
    int currentDay = DateTime.now().weekday;
    int day = currentDay;

    for (int i=1; i<=5; i++) {
      if (day >= 6) day = 1;
      dayIndices.add(day);
      day++;
    }

    return dayIndices;
  }

  @override
  initState() {
    if (kIsWeb && defaultTargetPlatform == TargetPlatform.android && BrainApp.preferences["showPlayStorePopup"]) {
      showDialog(
          context: context,
          builder: (context) {
            return BrainConfirmationDialog(
              title: "Für Android Benutzer",
              description: "Die Brain App ist auch im Playstore erhältlich",
              onCancel: () {
                BrainApp.updatePreference("showPlayStorePopup", false);
                Navigator.of(context).pop();
              },
              onContinue: () {
                Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.brain.brain_app");
                launchUrl(url, mode: LaunchMode.externalApplication);
              }
            );
          }
      );
    }
    super.initState();
  }

  List<Widget> getDays(){
    List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];

    List<Widget> days = [];
    List<int> dayIndexes = getDayIndices();
    for(int i = 0; i < dayIndexes.length; i++){
      String headline = weekDays[dayIndexes[i] - 1];
      if(dayIndexes[i] == DateTime.now().weekday) headline = "Stundenplan Heute";
      if(dayIndexes[i] == DateTime.now().weekday + 1) headline = "Stundenplan Morgen";
      if(TimeTable.getSubjects(dayIndexes[i]).isNotEmpty) days.add(HomePageDay(day: dayIndexes[i], headline: headline,));
    }

    if (days.isEmpty) {
      return [
        Box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.colors.text),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Icon(Icons.add_box_rounded, size: 40, color: AppDesign.colors.text)
                  ),
                  Icon(Icons.add_box_outlined, size: 40, color: AppDesign.colors.text)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Dein Stundenplan ist noch leer",
                  style: AppDesign.textStyles.boxHeadline.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Füge ein neues Fach hinzu oder fülle deinen Stundenplan aus :)",
                  textAlign: TextAlign.center,
                  style: AppDesign.textStyles.pointElementSecondary,
                )
              ),
              Flex(
                crossAxisAlignment: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
                    ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
                direction: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
                    ? Axis.horizontal : Axis.vertical,
                children: getButtons(MediaQuery.of(context).size.width > AppDesign.breakPointWidth)
              )
            ]
          )
        )
      ];
    }

    return days;
  }

  List<Widget> getButtons(bool asRow) {
    Widget button1 = TextButton(
      style: TextButton.styleFrom(
          foregroundColor: AppDesign.colors.contrast,
          backgroundColor: AppDesign.colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15)
      ),
      onPressed: () => NavigationHelper.pushNamed(context, "timeTable"),
      child: Text("Stundenplan", style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)),
    );
    Widget button2 = Padding(
        padding: asRow
            ? const EdgeInsets.only(left: 10)
            : const EdgeInsets.only(top: 5),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: AppDesign.colors.primary,
              foregroundColor: AppDesign.colors.contrast,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15)
          ),
          onPressed: () => NavigationHelper.pushNamed(context, "subjectPage"),
          child: Text("Neues Fach", style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)),
        )
    );

    return [
      asRow ? Expanded(
        child: button1,
      ) : button1,
      asRow ? Expanded(
        child: button2,
      ) : button2
    ];
  }

  Widget getHeader(){
      int homework = TimeTable.homeworks.length;

      DateTime nextHomework = DateTime(99999);
      for(Homework hom in TimeTable.homeworks){
        if(nextHomework.isAfter(hom.dueTime)) nextHomework = hom.dueTime;
      }

      int eventsCount = TimeTable.getEvents(DateTime.now()).length;
      IconData eventsIcon;
      String eventsText = "";
      if (eventsCount > 0) {
        eventsIcon = Icons.warning_rounded;
        eventsText = "Du hast heute noch ${eventsCount.toString()} Termin${eventsCount == 1 ? "" : "e"}!";
      } else {
        eventsIcon = Icons.check_circle_rounded;
        eventsText = "Du hast heute keine Termine";
      }

      IconData homeworkIcon = Icons.check_circle_rounded;
      String homeworkText = "Du hast schon alle Hausaufgaben erledigt";
      if(homework > 0) {
        homeworkIcon = Icons.warning_rounded;
        homeworkText = "Du hast noch ${homework.toString()} unerledigte Hausaufgabe${homework == 1 ? "" : "n"}!";
      }

      return NotificationListener<OverscrollNotification> (
        onNotification: (notification) => notification.metrics.axisDirection != AxisDirection.down,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            children: [
              BrainInfobox(
                isPrimary: true,
                title: homeworkText,
                shortDescription: "Hausaufgaben",
                icon: homeworkIcon,
              ),
              BrainInfobox(
                title: eventsText,
                shortDescription: "Termine",
                icon: eventsIcon,
                action: () {
                  CalendarPage.selectedDay = DateTime.now();
                  NavigationHelper.selectedPrimaryPage.value = 2;
                  NavigationHelper.pushNamedReplacement(context, "calendar");
                },
              ),
              if (BrainApp.preferences["showMediaBox"] && BrainApp.todaysMedia != null) BrainInfobox(
                  title: BrainApp.todaysMedia!.content,
                  shortDescription: BrainApp.todaysMedia!.type,
                  icon: BrainApp.todaysMedia!.icon
              )
            ],
          ),
        )
      );
  }

  List<Widget> staggeredChildren() {
    if (HomePage.timesRun <= 1) {
      HomePage.timesRun++;
      return AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (child) => SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(
                child: child,
              )
          ),
          children: getDays()
      );
    } else {
      return getDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (MediaQuery.of(context).size.width < AppDesign.breakPointWidth) {
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 0;
            NavigationHelper.pushNamedReplacement(context, "gradesOverview");
          } else if (details.velocity.pixelsPerSecond.dx < 0.0) {
            NavigationHelper.selectedPrimaryPage.value = 2;
            NavigationHelper.pushNamedReplacement(context, "calendar");
          }
        }
      },
      child: PageTemplate(
        title: 'Übersicht',
        secondaryTitleButton: true ? null : TextButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                backgroundColor: AppDesign.colors.secondaryBackground,
                minimumSize: Size.zero
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  bool shareHomework = false;
                  bool shareTimetable = false;
                  bool shareGrades = false;
                  bool shareTests = false;
                  return AlertDialog(
                    contentPadding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                    backgroundColor: AppDesign.colors.secondaryBackground,
                    title: Text("Was willst du teilen?", style: AppDesign.textStyles.alertDialogHeader),
                    content: StatefulBuilder(
                      builder: (context, setBuilderState) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SettingsSwitchButton(
                                text: "Hausaufgaben",
                                state: shareHomework,
                                action: () => setBuilderState(() => shareHomework = !shareHomework),
                              ),
                              SettingsSwitchButton(
                                text: "Stundenplan",
                                state: shareTimetable,
                                action: () => setBuilderState(() => shareTimetable = !shareTimetable),
                              ),
                              SettingsSwitchButton(
                                text: "Noten",
                                state: shareGrades,
                                action: () => setBuilderState(() => shareGrades = !shareGrades),
                              ),
                              SettingsSwitchButton(
                                text: "Tests",
                                state: shareTests,
                                action: () => setBuilderState(() => shareTests = !shareTests),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: AppDesign.colors.primary,
                                    foregroundColor: AppDesign.colors.contrast
                                  ),
                                  onPressed: () {
                                    // TODO: Sachen machen sebastian merk
                                  },
                                  child: Text("Teilen", style: AppDesign.textStyles.buttonText.copyWith(fontSize: 16)),
                                ),
                              )
                            ]
                        );
                      }
                    )
                  );
                }
              );
            },
            child: Semantics(
              label: "Teilen",
              child: Icon(Icons.share, color: AppDesign.colors.text),
            )
        ),
        floatingActionButton: BrainMenuButton(
          defaultAction: () => NavigationHelper.pushNamed(context, "homework"),
          defaultLabel: "Neu",
        ),
        child: Wrap(
          runSpacing: 20,
          children: Initializer.initialized
            ? staggeredChildren()
            : []
        ),
        floatingHeader: getHeader()
      ),
    );
  }
}
import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_interval.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Backend/todo.dart';
import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/main.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/brain_confirmation_dialog.dart';
import 'brain_debug.dart';
import 'design.dart';
import 'event.dart';
import 'grade.dart';
import 'homework.dart';
import 'notifications.dart';

class Initializer {
  static bool initialized = false;

  static Future init() async {
    getPreferences().then((value) {
      AppDesign.toggleTheme(BrainApp.preferences["design"]);
      GradingSystem.isAdvancedLevel = BrainApp.preferences["isAdvancedLevel"];
      GradingSystem.currentYear = BrainApp.preferences["currentYear"];

      BrainDebug.log("Loaded preferences successfully");
      showAndroidPopup();
    });
    TimeTable.init();
    CustomNotifications.init();
    await loadData();
    BrainDebug.log("Loaded data successfully");
    await getBoxText();
    BrainDebug.log("Gotten box text successfully");
    await getVersion();
    BrainVibrations.init();
    initialized = true;
  }

  static void showAndroidPopup() {
    if (kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        BrainApp.preferences["showPlayStorePopup"]) {
      BrainDebug.log("Showing Android Popup");
      showDialog(
          context: NavigationHelper.rootKey.currentContext!,
          builder: (context) {
            return BrainConfirmationDialog(
                title: "Brain App im Playstore",
                description:
                    "Android Nutzer können die Brain App auch ganz bequem aus dem Playstore herunterladen",
                onCancel: () {
                  BrainApp.updatePreference("showPlayStorePopup", false);
                  Navigator.of(context).pop();
                },
                onContinue: () {
                  Uri url = Uri.parse(
                      "https://play.google.com/store/apps/details?id=com.brain.brain_app");
                  launchUrl(url, mode: LaunchMode.externalApplication);
                });
          });
    }
    return;
  }

  static Future getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BrainApp.preferences.forEach((key, value) {
      BrainApp.preferences[key] = prefs.get(key) ?? value;
    });
  }

  static Future getBoxText() async {
    TodaysMedia? media = await parseJokes();
    if (media != null) {
      BrainApp.todaysMedia = media;
    }
  }

  static Future<TodaysMedia?> parseJokes() async {
    final rawData = await rootBundle.loadString("data/witze.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    for (List<dynamic> entry in listData) {
      List<String> splitDate = (entry[0] as String).split(".");
      if (splitDate.length <= 2) return null;
      DateTime parsedTime =
          DateTime.parse("${splitDate[2]}-${splitDate[1]}-${splitDate[0]}");
      DateTime now = DateTime.now();

      if (parsedTime.year == now.year &&
          parsedTime.month == now.month &&
          parsedTime.day == now.day) {
        IconData icon;
        String type = entry[1];
        type = type.trim();

        String content = entry[2];

        switch (type) {
          case "Fun Fact":
            icon = Icons.lightbulb;
            break;
          case "Witz":
            icon = Icons.celebration;
            break;
          case "Tipp":
            icon = Icons.verified;
            break;
          case "Zitat":
            icon = Icons.format_quote;
            break;
          case "Vorschlag":
            icon = Icons.star_border;
            break;
          case "Quiz":
            icon = Icons.question_mark_rounded;
            break;
          case "Ferien":
            icon = Icons.celebration;
            content = "Endlich Ferien!";
            break;
          default:
            return null;
        }

        return TodaysMedia(icon: icon, content: content, type: type);
      }
    }
    return null;
  }

  static Future getVersion() async {
    try {
      PackageInfo info = await PackageInfo.fromPlatform();
      BrainApp.appVersion = info.version;
      BrainDebug.log("Gotten version successfully");
    } catch (error) {
      BrainDebug.log("getVersion Error: $error");
    }
  }

  static void loadSubjects(dynamic subjects) {
    if (subjects != null) {
      for (Map item in subjects) {
        List color = item["color"];
        Subject.fromID(item["name"],
            Color.fromARGB(255, color[0], color[1], color[2]), item["id"]);
      }
    } else {
      BrainDebug.log("No Subjects");
    }
  }

  static void loadLinkedSubjects(dynamic linkedSubjects) {
    if (linkedSubjects != null) {
      for (Map item in linkedSubjects) {
        List color = item["color"];
        List<Subject> linkSubjects = [];
        List<int> evaluations = [];
        for (int i in item["subjectIDs"]) {
          linkSubjects.add(TimeTable.getSubject(i)!);
        }
        for (int i in item["subjectEvaluations"]) {
          evaluations.add(i);
        }

        LinkedSubject(
            item["name"],
            Color.fromARGB(255, color[0], color[1], color[2]),
            linkSubjects,
            evaluations);
      }
    } else {
      BrainDebug.log("No Linked Subjects");
    }
  }

  static void loadTimeTable(dynamic timetable) {
    if (timetable != null) {
      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 10; j++) {
          int id = timetable[i][j];
          Subject? subject = TimeTable.getSubject(id);
          if (id != 0 && subject != null) {
            SubjectInstance(subject, i + 1, j);
          } else if (id != 0) {
            BrainDebug.log("loadData() Timetable Error: Fach existiert nicht!");
          }
        }
      }
    } else {
      BrainDebug.log("No Time Table");
    }
  }

  static void loadHomework(dynamic homework) {
    int deletedHomework = 0;

    if (homework != null) {
      for (Map item in homework) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        Subject? subject = TimeTable.getSubject(id);
        if (subject != null) {
          if (!(BrainApp.preferences["deleteOldHomework"] && time.isBefore(DateTime.now()))) {
            Homework(TimeTable.getSubject(id)!, time, item["name"]);
          } else {
            deletedHomework++;
          }
        } else {
          BrainDebug.log("loadData() Homework Error: Fach existiert nicht!");
        }
      }
    } else {
      BrainDebug.log("No Homework");
    }

    if (deletedHomework > 0) {
      SaveSystem.saveHomework();
      BrainToast toast = BrainToast(text: "${deletedHomework == 1
          ? "1 Hausaufgabe wurde"
          : "$deletedHomework Hausaufgaben wurden"} gelöscht");
      toast.show();
    }
  }

  static void loadEvents(dynamic events) {
    if (events != null) {
      for (Map item in events) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        if(item["isNote"] != null){
          Note(time,item["description"]);
        }
        else{
          Event(time, item["name"], item["description"]);
        }

      }
    } else {
      BrainDebug.log("No Events");
    }
  }

  static void loadTests(dynamic tests) {
    if (tests != null) {
      for (Map item in tests) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        Subject? subject = TimeTable.getSubject(id);
        if (subject != null) {
          Test(subject, time, item["description"]);
        } else {
          BrainDebug.log("loadData() Test Error: Fach existiert nicht!");
        }
      }
    } else {
      BrainDebug.log("No Tests");
    }
  }

  static void loadGrades(dynamic grades) {
    if (grades != null) {
      for (Map item in grades) {
        int value = item["value"];
        int id = item["SubjectID"];
        GradeTime time = GradeTime.createOnLoad(
            item["year"], item["partOfYear"], item["isAdvanced"]);
        String? name = item["name"];
        name ??= "Note";

        if (TimeTable.getSubject(id) != null) {
          if (item["isBig"]) {
            BigGrade.createWithTime(
                value, TimeTable.getSubject(id)!, time, name);
          } else {
            GradeType type = Grade.stringToGradeType(item["type"]);
            SmallGrade.createWithTime(
                value, TimeTable.getSubject(id)!, type, time, name);
          }
        } else {
          BrainDebug.log("loadData() Grades Error: Fach existiert nicht!");
        }
      }
    } else {
      BrainDebug.log("No Grades");
    }
  }

  static void loadLessonTimes(lessonTimes){
    if (lessonTimes != null) {
      for (int i = 0; i < TimeTable.lessonTimes.length; i++) {
        List l = lessonTimes[i];
        TimeTable.lessonTimes[i] = TimeInterval(
            TimeOfDay(hour: l[0][0], minute: l[0][1]),
            TimeOfDay(hour: l[1][0], minute: l[1][1]));
      }
    } else {
      BrainDebug.log("No Lesson Times");
    }
  }

  static void loadAdvancedLevels(advancedLevels){
    if (advancedLevels != null) {
      advancedLevels.forEach((key, value) {
        GradingSystem.yearsToLevel[int.parse(key)] = value;
      });
    }
  }

  static void loadToDos(toDos){
    if (toDos != null) {
      for (Map item in toDos) {
        ToDoImportance importance = ToDoImportance.values[item["importance"]];
        ToDoItem.load(item["content"], importance, item["done"]);
      }
    } else {
      BrainDebug.log("No to dos");
    }

  }

  static void loadDevOptions(devOptions){
    if (devOptions != null) {
      for (String code in devOptions) {
        BrainDebug.log(code);
        if (!DeveloperOptions.activatedCodes.contains(code)) {
          DeveloperOptions.activatedCodes.add(code);
        }
      }
    } else {
      BrainDebug.log("No Dev Options");
    }
  }

  static Future loadData() async {
    TimeTable.saveEnabled = false;

    dynamic lessonTimes = await SaveSystem.getLessonTimes();
    dynamic subjects = await SaveSystem.getSubjects();
    dynamic linkedSubjects = await SaveSystem.getLinkedSubjects();
    dynamic timetable = await SaveSystem.getTimeTable();
    dynamic homework = await SaveSystem.getHomework();
    dynamic events = await SaveSystem.getEvents();
    dynamic tests = await SaveSystem.getTests();
    dynamic advancedLevels = await SaveSystem.getAdvancedLevels();
    dynamic grades = await SaveSystem.getGrades();
    dynamic toDos = await SaveSystem.getToDos();
    dynamic devOptions = await SaveSystem.getDeveloperOptions();

    loadLessonTimes(lessonTimes);
    loadSubjects(subjects);
    loadLinkedSubjects(linkedSubjects);
    loadTimeTable(timetable);
    loadHomework(homework);
    loadEvents(events);
    loadTests(tests);
    loadAdvancedLevels(advancedLevels);
    loadGrades(grades);
    loadToDos(toDos);
    loadDevOptions(devOptions);


    TimeTable.saveEnabled = true;
  }
}

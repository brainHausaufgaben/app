import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/main.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design.dart';
import 'event.dart';
import 'grade.dart';
import 'homework.dart';
import 'notifications.dart';

class Initializer {
  static Future init() async {
    getPreferences().then(
      (value) => AppDesign.toggleTheme(BrainApp.preferences["design"])
    );
    TimeTable.init();
    await CustomNotifications.init();
    await loadData();
    await getBoxText();
    await getVersion();
  }

  static Future getVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    BrainApp.appVersion = info.version;
  }
  
  static Future getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BrainApp.preferences.forEach((key, value) {
      BrainApp.preferences[key] = prefs.get(key) ?? value;
    });
  }

  static Future getBoxText() async {
    parseJokes().then((value) {
      if (value != null) {
        BrainApp.todaysMedia = value;
      }
    });
  }

  static Future<TodaysMedia?> parseJokes() async {
    final rawData = await rootBundle.loadString("data/witze.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    for (List<dynamic> entry in listData) {
      List<String> splitDate = (entry[0] as String).split(".");
      if (splitDate.length <= 2) return null;
      DateTime parsedTime = DateTime.parse("${splitDate[2]}-${splitDate[1]}-${splitDate[0]}");
      DateTime now = DateTime.now();

      if (parsedTime.year == now.year && parsedTime.month == now.month && parsedTime.day == now.day) {
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

        return TodaysMedia(
            icon: icon,
            content: content,
            type: type
        );
      }
    }
    return null;
  }
  
  static Future loadData() async{
    TimeTable.saveEnabled = false;

    dynamic subjects = await SaveSystem.getSubjects();
    if (subjects != null) {
      for (Map item in subjects) {
        List color = item["color"];
        Subject.fromID(
            item["name"], Color.fromARGB(255, color[0], color[1], color[2]),
            item["id"]);
      }
    }

    dynamic timetable = await SaveSystem.getTimeTable();
    if (timetable != null) {
      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 10; j++) {
          int id = timetable[i][j];
          Subject? subject = TimeTable.getSubject(id);
          if (id != 0 && subject != null) SubjectInstance(subject, i + 1, j);
        }
      }
    }

    dynamic homework = await SaveSystem.getHomework();
    if(homework != null) {
      for (Map item in homework) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        if (TimeTable.getSubject(id)!.getTime(TimeTable.getDayFromDate(time)) !=
            null) Homework(TimeTable.getSubject(id)!, time, item["name"]);
      }

    }

    dynamic events = await SaveSystem.getEvents();
    if(events != null) {
      for (Map item in events) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        Event(time, item["name"], item["description"]);
      }
    }

    dynamic tests = await SaveSystem.getTests();
    if(tests != null) {
      for (Map item in tests) {
        List t = item["dueTime"];
        DateTime time = DateTime(t[0], t[1], t[2]);
        int id = item["SubjectID"];
        Test(TimeTable.getSubject(id)!, time, item["description"]);
      }
    }

    dynamic grades = await SaveSystem.getGrades();
    if(grades != null) {
      for (Map item in await SaveSystem.getGrades()) {
        int value = item["value"];
        int id = item["SubjectID"];
        GradeTime time = GradeTime.createOnLoad(item["year"],item["partOfYear"],item["isAdvanced"]);

        if(item["isBig"]) {
          BigGrade.createWithTime(value,TimeTable.getSubject(id)!,time);
        } else {
          GradeType type = Grade.stringToGradeType(item["type"]);
          SmallGrade.createWithTime(value,TimeTable.getSubject(id)!,type,time);
        }

      }
    }

    TimeTable.saveEnabled = true;
  }
}
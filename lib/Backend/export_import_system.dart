import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'grade.dart';

class ExportImport {
  static Map typeToString = {
    FileType.timetableReliantOnly: "tro",
    FileType.timetableOnly: "tto",
    FileType.all: "all",
    FileType.none: "nan",
  };

  static Map getFile(bool timetable, bool homework, bool grades, bool events) {
    FileType type;
    List subjectData = [];
    List linkedSubjectData = [];
    List timetableData = [];
    List homeworkData = [];
    List gradesData = [];
    List eventsData = [];
    List testData = [];
    Map file = {};
    if (timetable && !homework && !grades && !events) {
      type = FileType.timetableOnly;
    } else if (timetable && (homework || grades || events)) {
      type = FileType.all;
    } else if (!timetable && (homework || grades || events)) {
      type = FileType.timetableReliantOnly;
    } else {
      type = FileType.none;
    }
    if (type == FileType.all || type == FileType.timetableOnly) {
      timetableData = TimeTable.timeTableToJSONEncodable();
      subjectData = TimeTable.subjectsToJSONEncodeble();
      linkedSubjectData = TimeTable.linkedSubjectsToJSONEncodable();
    }
    if (homework) homeworkData = getHomework();
    if (grades) gradesData = getGrades();
    if (events) {
      eventsData = TimeTable.eventsToJSONEncodable();
      testData = getTests();
    }

    file["type"] = typeToString[type];
    file["subjects"] = subjectData;
    file["timetable"] = timetableData;
    file["homework"] = homeworkData;
    file["grades"] = gradesData;
    file["events"] = eventsData;
    file["tests"] = testData;
    file["linked"] = linkedSubjectData;
    return file;
  }

  static void load(Map map) {
    String type = map["type"];
    LocalStorage storage = LocalStorage("brain_app");
    switch (type) {
      case "all":
        storage.setItem("subjects", map["subjects"]);
        storage.setItem("time_table", map["timetable"]);
        storage.setItem("homework", map["homework"]);
        storage.setItem("grades", map["grades"]);
        storage.setItem("events", map["events"]);
        storage.setItem("tests", map["tests"]);
        storage.setItem("linkedSubjects", map["linked"]);
        //TODO: sachen die machen das die app neu startet miau :3
        break;
      case "tto":
        dynamic subjects = map["subjects"];
        if (subjects != null) {
          for (Map item in subjects) {
            List color = item["color"];
            Subject.fromID(item["name"],
                Color.fromARGB(255, color[0], color[1], color[2]), item["id"]);
          }
        }
        dynamic linkedSubjects = map["linked"];
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
        }
        dynamic timetable = map["timetable"];
        if (timetable != null) {
          for (int i = 0; i < 7; i++) {
            for (int j = 0; j < 10; j++) {
              int id = timetable[i][j];
              Subject? subject = TimeTable.getSubject(id);
              if (id != 0 && subject != null) {
                SubjectInstance(subject, i + 1, j);
              } else if (id != 0) {
                BrainDebug.log(
                    "loadData() Timetable Error: Fach existiert nicht!");
              }
            }
          }
        }
        break;
      case "tro":
        dynamic homework = map["homework"];
        if (homework != null) {
          for (Map item in homework) {
            List t = item["dueTime"];
            DateTime time = DateTime(t[0], t[1], t[2]);
            int id = item["SubjectID"];
            Subject? subject = TimeTable.getSubject(id);
            if (subject != null) {
              if (TimeTable.getSubject(id)!
                      .getTime(TimeTable.getDayFromDate(time)) !=
                  null) Homework(TimeTable.getSubject(id)!, time, item["name"]);
            } else {
              BrainDebug.log(
                  "loadData() Homework Error: Fach existiert nicht!");
            }
          }
        }
        dynamic events = map["events"];
        if (events != null) {
          for (Map item in events) {
            List t = item["dueTime"];
            DateTime time = DateTime(t[0], t[1], t[2]);
            Event(time, item["name"], item["description"]);
          }
        }
        dynamic tests = map["test"];
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
        }
        dynamic grades = map["grades"];
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
        }
        break;
    }
  }

  static List getHomework() {
    return TimeTable.homeworks.map((item) {
      Map homework = item.toJSONEncodable();
      homework["subjectName"] =
          TimeTable.getSubject(homework["SubjectID"])!.name;
      return homework;
    }).toList();
  }

  static List getGrades() {
    List<Grade> grades = List.from(GradingSystem.smallGrades)
      ..addAll(GradingSystem.bigGrades);
    return grades.map((item) {
      Map gradesMap = item.toJSONEncodable();
      gradesMap["subjectName"] =
          TimeTable.getSubject(gradesMap["SubjectID"])!.name;
      return gradesMap;
    }).toList();
  }

  static List getTests() {
    return TimeTable.tests.map((item) {
      Map test = item.toJSONEncodable();
      test["subjectName"] = TimeTable.getSubject(test["SubjectID"])!.name;
      return test;
    }).toList();
  }

  static Future<void> writeFile(String name,bool timetable, bool homework, bool grades, bool events) async {
    Map data = getFile(timetable, homework, grades, events);
    BrainDebug.log(data);
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/name.brain');
      file.writeAsString(data.toString());
    } else {
      launchUrl(Uri.parse("data:application/octet-stream;base64,${base64Encode(data.toString().codeUnits)}"));
    }
  }
}

enum FileType {
  timetableOnly,
  timetableReliantOnly,
  all,
  none,
}

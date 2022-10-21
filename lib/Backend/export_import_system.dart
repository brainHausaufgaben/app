import 'dart:convert';
import 'dart:ui';

import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/initializer.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/subject_instance.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import 'grade.dart';

class ExportImport {
  static Map typeToString = {
    FileType.timetableReliantOnly: "tro",
    FileType.timetableOnly: "tto",
    FileType.all: "all",
    FileType.none: "nan",
  };

  static void userSelectedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      load(jsonDecode(String.fromCharCodes(result.files[0].bytes!)));
    }
  }

  static Map getFile(bool timetable, bool homework, bool grades, bool events) {
    FileType type;
    List subjectData = [];
    List linkedSubjectData = [];
    List timetableData = [];
    List homeworkData = [];
    List gradesData = [];
    List eventsData = [];
    List testData = [];
    Map idToName = {};
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
    else{
      for(Subject subject in TimeTable.subjects){
        idToName[subject.id] = subject.name;
      }
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
    file["idToName"] = idToName;
    return file;
  }


  static void load(Map map, {Map<int, Subject>? loadSubjectToSubject}) {
    String type = map["type"];
    LocalStorage storage = LocalStorage("brain_app");
    switch (type) {
      case "all":
        dynamic timetable = map["timetable"];
        dynamic subjects = map["subjects"];
        dynamic linkedSubjects = map["linked"];
        dynamic homework = map["homework"];
        dynamic grades = map["grades"];
        dynamic tests = map["tests"];
        dynamic events = map["events"];
        int lastID = Subject.lastID;
        if(homework != null) {
          for (Map item in homework) {
            item["SubjectID"] = item["SubjectID"] + lastID;
          }
        }
        if(grades != null) {
          for (Map item in grades) {
            item["SubjectID"] = item["SubjectID"] + lastID;
          }
        }
        if(tests != null) {
          for (Map item in tests) {
            item["SubjectID"] = item["SubjectID"] + lastID;
          }
        }

        deleteTimeTable();
        Initializer.loadTimeTable(timetable);
        Initializer.loadSubjects(subjects);
        Initializer.loadLinkedSubjects(linkedSubjects);
        Initializer.loadHomework(homework);
        Initializer.loadGrades(grades);
        Initializer.loadTests(tests);
        Initializer.loadEvents(events);
        //TODO: das geht jetzt villeciht aber bisschen testen oder so
        break;
      case "tto":
        dynamic timetable = map["timetable"];
        dynamic subjects = map["subjects"];
        dynamic linkedSubjects = map["linked"];
        deleteTimeTable();
        Initializer.loadTimeTable(timetable);
        Initializer.loadSubjects(subjects);
        Initializer.loadLinkedSubjects(linkedSubjects);
        break;
      case "tro":
        dynamic homework = map["homework"];
        dynamic grades = map["grades"];
        dynamic tests = map["tests"];
        dynamic events = map["events"];
        if(homework != null){
          for(Map item in homework){
            item["SubjectID"] = loadSubjectToSubject![item["SubjectID"]]!.id;
          }
        }
        if(grades != null){
          for(Map item in grades){
            item["SubjectID"] = loadSubjectToSubject![item["SubjectID"]]!.id;
          }
        }
        if(tests != null){
          for(Map item in tests){
            item["SubjectID"] = loadSubjectToSubject![item["SubjectID"]]!.id;
          }
        }
        Initializer.loadHomework(homework);
        Initializer.loadGrades(grades);
        Initializer.loadTests(tests);
        Initializer.loadEvents(events);
        break;
    }
  }

  static void deleteTimeTable(){
    for(Day day in TimeTable.week){
      for(int i = 0; i < day.subjects.length; i++){
        day.subjects[i] = null;
      }
    }
  }

  static Map getSubjectNames(Map idToName){
    Map<String,List> out = {};
    idToName.forEach((key, value) {
      for(Subject subject in TimeTable.subjects){
        if(value.toString().toLowerCase() == subject.name.toLowerCase()){
          out[value] = [subject,key];
        }
        else {
          out[value] = [null,key];
        }
      }

    });
    return out;
  }

  static Map convertSubjectNamesMap(Map<String,List> map){
    Map<int,Subject> out = {};
    map.forEach((key, value) {
      out[value[0]] = value[1];
    });
    return out;
  }

  static List getHomework() {
    return TimeTable.homeworks.map((item) {
      Map homework = item.toJSONEncodable();
      homework["subjectName"] =
          TimeTable.getSubject(homework["SubjectID"])!.name;
      return homework;
    }).toList();
  }

  static void parseSubjects() {

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

    FileSaver.instance.saveFile("export.brain", Uint8List.fromList(jsonEncode(data).codeUnits), "brain", mimeType: MimeType.TEXT);
  }
}

enum FileType {
  timetableOnly,
  timetableReliantOnly,
  all,
  none,
}

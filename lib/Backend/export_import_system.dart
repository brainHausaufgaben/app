import 'dart:io';

import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'grade.dart';


class ExportImport{

  static Map typeToString = {
    FileType.timetableReliantOnly : "tro",
    FileType.timetableOnly : "tto",
    FileType.all : "all",
    FileType.none : "nan",
  };





  static Map getFile(bool timetable, bool homework, bool grades, bool events){
    FileType type;
    List subjectData = [];
    List timetableData = [];
    List homeworkData = [];
    List gradesData = [];
    List eventsData = [];
    List testData = [];
    Map file = {} ;
    if(timetable && !homework && !grades && !events) {
      type = FileType.timetableOnly;
    } else if(timetable && (homework || grades || events)) {
      type = FileType.all;
    } else if(!timetable && (homework || grades || events)) {
      type = FileType.timetableReliantOnly;
    } else {
      type = FileType.none;
    }
    if(type == FileType.all || type == FileType.timetableOnly){
      timetableData = TimeTable.timeTableToJSONEncodable();
      subjectData = TimeTable.subjectsToJSONEncodeble();
    }
    if(homework) homeworkData = getHomework();
    if(grades) gradesData = getGrades();
    if(events){
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

    return file;
  }

  static void load(Map map){
    String type = map["type"];





  }

  static List getHomework(){
    return TimeTable.homeworks.map((item)
    {
      Map homework = item.toJSONEncodable();
      homework["subjectName"] = TimeTable.getSubject(homework["SubjectID"])!.name;
      return homework;
    }
    ).toList();

  }

  static List getGrades() {
    List<Grade> grades = List.from(GradingSystem.smallGrades)
      ..addAll(GradingSystem.bigGrades);
    return grades.map((item) {
      Map gradesMap = item.toJSONEncodable();
      gradesMap["subjectName"] =
          TimeTable.getSubject(gradesMap["SubjectID"])!.name;
      return gradesMap;
    }
    ).toList();
  }

  static List getTests(){
    return TimeTable.tests.map((item)
    {
      Map test = item.toJSONEncodable();
      test["subjectName"] = TimeTable.getSubject(test["SubjectID"])!.name;
      return test;
    }
    ).toList();

  }

  static Future<void> writeFile(String name,bool timetable, bool homework, bool grades, bool events) async {

    Map data = getFile(timetable, homework, grades, events);
    BrainDebug.log(data);
    if(!kIsWeb){
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file =  File('$path/name.brain');
      file.writeAsString(data.toString());
    }
  }
}











enum FileType{
  timetableOnly,
  timetableReliantOnly,
  all,
  none,


}
import 'dart:convert';

import 'package:brain_app/Backend/day.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/event.dart';
import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/homework.dart';
import 'package:brain_app/Backend/initializer.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/test.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/brain_inputs.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'grade.dart';

class ExportImport {
  static Map typeToString = {
    FileType.timetableReliantOnly: "tro",
    FileType.timetableOnly: "tto",
    FileType.all: "all",
    FileType.none: "nan",
  };

  static List<Widget> getImportPages(Map names) {
    List<Widget> output = [];

    names.forEach((key, value) {
      output.add(
          Flex(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppDesign.colors.background,
                  borderRadius: AppDesign.boxStyle.inputBorderRadius
                ),
                padding: const EdgeInsets.all(10),
                child: Text(key),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Icon(Icons.arrow_circle_down_rounded, color: AppDesign.colors.text),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppDesign.colors.background,
                    borderRadius: AppDesign.boxStyle.inputBorderRadius
                ),
                padding: const EdgeInsets.all(10),
                child: StatefulBuilder(
                  builder: (context, setBuilderState) {
                    return BrainDropdown(
                        currentValue: value[0],
                        dialogTitle: "Wähle ein Fach",
                        defaultText: "Wähle ein Fach",
                        items: BrainDropdown.getSubjectDropdowns(),
                        onChanged: (chosenSubject) {
                          setBuilderState(() {
                            value[0] = chosenSubject;
                          });
                        }
                    );
                  }
                )
              )
            ]
          )
      );
    });

    return output;
  }

  static void userSelectedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Map decodedData = jsonDecode(String.fromCharCodes(result.files[0].bytes!));
      Map names = getSubjectNames(decodedData["idToName"]);

      PageController pageController = PageController();
      List<Widget> pages = getImportPages(names);
      if(decodedData["type"] == "tro") {
        showDialog(
            context: NavigationHelper.rootKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                  title: StatefulBuilder(
                      builder: (context, setBuilderState) {
                        pageController.addListener(() {
                          setBuilderState(() {});
                        });
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Fächer Zuweisung",
                                  style: AppDesign.textStyles
                                      .alertDialogHeader),
                              Text("${pageController.hasClients ? pageController
                                  .page!.round() + 1 : 1}/${pages.length}",
                                  style: AppDesign.textStyles.alertDialogHeader)
                            ]
                        );
                      }
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (pageController.page == 0) Navigator.of(context)
                              .pop();
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        child: Text("Zurück")
                    ),
                    TextButton(
                        onPressed: () {
                          if (pageController.page == pages.length - 1) {
                            load(decodedData,
                                loadSubjectToSubject: convertSubjectNamesMap(
                                    names));
                            Navigator.of(context).pop();
                          }
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        child: Text("Weiter")
                    )
                  ],
                  content: SizedBox(
                      width: 250,
                      height: 180,
                      child: PageView(
                        controller: pageController,
                        children: pages,
                      )
                  )
              );
            }
        );
      }
      else{
        load(decodedData);
        //TODO: dialog machen der sagt das dein stundenplan überschrieben wird ok ist das was x3
      }
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
    Map<String, String> idToName = {};
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
      if(homework){
        for(Homework homework in TimeTable.homeworks){
            Subject subject = homework.subject;
            idToName[subject.id.toString()] = subject.name;
        }
      }
      if(events){
        for(Test test in TimeTable.tests){
          Subject subject = test.subject;
          idToName[subject.id.toString()] = subject.name;
        }
      }
      if(grades){
        List<Grade> grades = GradingSystem.bigGrades;
        grades.addAll(GradingSystem.smallGrades);
        for(Grade grade in grades){
          Subject subject = grade.subject;
          idToName[subject.id.toString()] = subject.name;
        }
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
    switch (type) {
      case "all":
        print("sus");
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
        //TODO: machen das sachen refreshen du weist sicher was ich mein
        break;
      case "tto":
        dynamic timetable = map["timetable"];
        dynamic subjects = map["subjects"];
        dynamic linkedSubjects = map["linked"];
        deleteTimeTable();
        Initializer.loadTimeTable(timetable);
        Initializer.loadSubjects(subjects);
        Initializer.loadLinkedSubjects(linkedSubjects);
        //TODO: machen das sachen refreshen du weist sicher was ich mein
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
        else if (!out.containsKey(value)){
          out[value] = [null,key];
        }
      }

    });
    return out;
  }

  static Map<int,Subject> convertSubjectNamesMap(Map<dynamic, dynamic> map){
    Map<int,Subject> out = {};
    map.forEach((key, value) {
      out[int.parse(value[1])] = value[0];
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

  static void writeFile(String name,bool timetable, bool homework, bool grades, bool events) {
    Map data = getFile(timetable, homework, grades, events);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      FileSaver.instance.saveAs("export", Uint8List.fromList(jsonEncode(data).codeUnits), "brain", MimeType.OTHER);
    } else {
      FileSaver.instance.saveFile("export.brain", Uint8List.fromList(jsonEncode(data).codeUnits), "brain", mimeType: MimeType.TEXT);
    }
  }
}

enum FileType {
  timetableOnly,
  timetableReliantOnly,
  all,
  none,
}

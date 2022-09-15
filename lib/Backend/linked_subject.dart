import 'dart:ui';

import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class LinkedSubject extends Subject{
  List<Subject> subjects;
  List<int> evaluations;


  LinkedSubject(super.name, super.color,this.subjects,this.evaluations);

  @override
  void addToList() {
   TimeTable.addLinkedSubject(this);
  }

  @override
  void setID();

  void editLinked(String? newName,Color? newColor,List<Subject>? newSubjects,List<int>? newEvaluations ){
    if(newName != null) name = newName;
    if(newColor != null) color = newColor;
    if(newSubjects != null) subjects = newSubjects;
    if(newEvaluations != null)evaluations = newEvaluations;

    SaveSystem.saveLinkedSubjects();
  }

  @override
  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    List c = [];
    c.add(color.red);
    c.add(color.green);
    c.add(color.blue);
    List<int> subjectIDs = [];
    for (Subject subject in subjects) {
      subjectIDs.add(subject.id);
    }

    map["name"] = name;
    map["color"] = c;
    map["subjectIDs"] = subjectIDs;
    map["subjectEvaluations"] = evaluations;

    return map;
  }



}
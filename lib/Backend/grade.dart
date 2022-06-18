import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';

abstract class Grade{
  int value;
  Subject subject;

  Grade(this.value, this.subject){
    GradingSystem.addGrade(this);
  }
   Map toJSONEncodable();
}

class SmallGrade extends Grade{
  SmallGrade(int value, Subject subject) : super(value, subject);

   Map toJSONEncodable(){
    Map<String,dynamic> map = new Map();
    map["value"] = value;
    map["SubjectID"] = subject.id;
    map["isBig"] = false;
    return map;
  }

}

class BigGrade extends Grade{
  BigGrade(int value, Subject subject) : super(value, subject);

  Map toJSONEncodable(){
    Map<String,dynamic> map = new Map();
    map["value"] = value;
    map["SubjectID"] = subject.id;
    map["isBig"] = true;
    return map;
  }

}
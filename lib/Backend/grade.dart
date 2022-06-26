import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/subject.dart';

abstract class Grade{
  int value;
  Subject subject;
  GradeType type;
  late GradeTime time;

  Grade(this.value, this.subject,this.type, int partOfYear){
    time = GradeTime(GradingSystem.currentYear, partOfYear);
    GradingSystem.addGrade(this);
  }

  Grade.createWithTime(this.value,this.subject,this.type,this.time){
    GradingSystem.addGrade(this);
  }

  Map toJSONEncodable();

  String typeToString(){
    switch(type){
      case GradeType.oralGrade:
        return "Mündlich";
      case GradeType.smallTest:
        return "Ex";
      case GradeType.bigTest:
        return "Schulaufgabe";
    }
  }
}

class SmallGrade extends Grade{
  SmallGrade(int value, Subject subject,GradeType type, int partOfYear) : super(value, subject, type,partOfYear);
  SmallGrade.createWithTime(int value, Subject subject,GradeType type, GradeTime time) : super.createWithTime(value,subject,type,time);

   @override
  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    map["value"] = value;
    map["SubjectID"] = subject.id;
    map["isBig"] = false;
    map["type"] = typeToString();
    map["year"] = time.year;
    map["isAdvanced"] = time.isAdvancedLevel;
    map["partOfYear"] = time.partOfYear;
    return map;
  }

}

class BigGrade extends Grade{
  BigGrade(int value, Subject subject, int partOfYear) : super(value, subject,GradeType.bigTest,partOfYear);
  BigGrade.createWithTime(int value, Subject subject, GradeTime time) : super.createWithTime(value,subject,GradeType.bigTest,time);
  @override
  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    map["value"] = value;
    map["SubjectID"] = subject.id;
    map["isBig"] = true;
    map["year"] = time.year;
    map["isAdvanced"] = time.isAdvancedLevel;
    map["partOfYear"] = time.partOfYear;
    return map;
  }

}

enum GradeType{
  oralGrade,
  smallTest,
  bigTest,
}

class GradeTime{
  int year;
  int partOfYear;
  bool isAdvancedLevel = GradingSystem.isAdvancedLevel;

  GradeTime(this.year,this.partOfYear);
  GradeTime.createOnLoad(this.year,this.partOfYear,this.isAdvancedLevel);

}
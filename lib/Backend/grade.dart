import 'package:brain_app/Backend/grading_system.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';

abstract class Grade{
  String name;
  int value;
  Subject subject;
  GradeType type;
  late GradeTime time;

  Grade(this.value, this.subject, this.type,this.name, int partOfYear){
    time = GradeTime(GradingSystem.currentYear, partOfYear);
    GradingSystem.addGrade(this);
  }

  Grade.createWithTime(this.value,this.subject,this.type,this.time,this.name){
    GradingSystem.addGrade(this);
  }

  void edit(int? value,Subject? subject, GradeType? type,GradeTime? time,String? name ){
    if(value != null){
      this.value = value;
    }
    if(subject != null){
      this.subject = subject;
    }
    if(time != null){
      this.time = time;
    }
    if(name != null){
      this.name = name;
    }
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

  static GradeType stringToGradeType(String type){
    switch(type){
      case "Mündlich":
        return GradeType.oralGrade;
      case "Ex":
        return GradeType.smallTest;
      case "Schulaufgabe":
        return GradeType.bigTest;
      default:
        return GradeType.smallTest;
    }

  }

}

class SmallGrade extends Grade{
  SmallGrade(int value, Subject subject,GradeType type,String name, int partOfYear) : super(value, subject, type,name,partOfYear);
  SmallGrade.createWithTime(int value, Subject subject,GradeType type, GradeTime time,String name) : super.createWithTime(value,subject,type,time,name);

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
    map["name"] = name;
    return map;
  }
   @override
  void edit(int? value, Subject? subject, GradeType? type, GradeTime? time,String? name) {
    super.edit(value, subject, type, time,name);
    if(type != null){
      if(type == GradeType.bigTest){
        GradingSystem.removeGrade(this);
        BigGrade(this.value,this.subject,this.name,this.time.partOfYear);
      } else if (type != this.type) {
        this.type = type;
      }
    }
    SaveSystem.saveGrades();
  }

}

class BigGrade extends Grade{
  BigGrade(int value, Subject subject,String name, int partOfYear) : super(value, subject,GradeType.bigTest,name ,partOfYear);
  BigGrade.createWithTime(int value, Subject subject, GradeTime time,String name) : super.createWithTime(value,subject,GradeType.bigTest,time,name);
  @override
  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    map["value"] = value;
    map["SubjectID"] = subject.id;
    map["isBig"] = true;
    map["year"] = time.year;
    map["isAdvanced"] = time.isAdvancedLevel;
    map["partOfYear"] = time.partOfYear;
    map["name"] = name;
    return map;
  }

  @override
  void edit(int? value, Subject? subject, GradeType? type, GradeTime? time,String? name) {
    super.edit(value, subject, type, time,name);
    if(type != null){
      if(type != GradeType.bigTest){
        GradingSystem.removeGrade(this);
        SmallGrade(this.value,this.subject,type ,this.name ,this.time.partOfYear);
      }
    }
    SaveSystem.saveGrades();
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
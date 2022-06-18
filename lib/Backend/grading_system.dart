import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';

class GradingSystem{
  static bool isAdvancedLevel = true;
  static List<SmallGrade> smallGrades = [];
  static List<BigGrade> bigGrades = [];

  static void addGrade(Grade grade){
    if(grade.runtimeType == BigGrade) {
      bigGrades.add(grade as BigGrade);
    } else if(grade.runtimeType == SmallGrade) {
      smallGrades.add(grade as SmallGrade);
    }
    SaveSystem.saveGrades();
  }

  static List<SmallGrade> getSmallGradesBySubject(Subject subject){
    List<SmallGrade> output = [];
    smallGrades.map((e) => {if(e.subject == subject)output.add(e)});
    return output;
  }

  static List<BigGrade> getBigGradesBySubject(Subject subject){
    List<BigGrade> output = [];
    bigGrades.map((e) => {if(e.subject == subject)output.add(e)});
    return output;
  }
  static List gradesToJSONEncodable(){
    List<Grade> grades = List.from(smallGrades)..addAll(bigGrades);
    return grades.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();
  }


}


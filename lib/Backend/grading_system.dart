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

  static double getAverage(Subject subject){
    List<BigGrade> bigGradesSubject = getBigGradesBySubject(subject);
    List<SmallGrade> smallGradesSubject = getSmallGradesBySubject(subject);
    if(isAdvancedLevel){
      double bigGradeAverage = 0;
      double smallGradeAverage = 0;
      double a = 0;
      if(bigGrades.isNotEmpty){
        bigGradesSubject.map((e) => bigGradeAverage + e.value);
        bigGradeAverage /= bigGradesSubject.length as double;
        a++;
      }
      if(smallGrades.isNotEmpty){
        smallGradesSubject.map((e) => smallGradeAverage + e.value);
        smallGradeAverage /= smallGradesSubject.length as double;
        a++;
      }

      if(a == 0)return 0;
      return (smallGradeAverage + bigGradeAverage) / a;

    }
    else{
      double average = 0;
      bigGradesSubject.map((e) => average += e.value*2.0);
      smallGradesSubject.map((e) => average += e.value as double);

      if(smallGradesSubject.length + bigGradesSubject.length == 0) return 0;
      return average / (smallGradesSubject.length + bigGradesSubject.length);
    }
  }



}


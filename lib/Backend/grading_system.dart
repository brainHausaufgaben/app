import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class GradingSystem{
  static bool isAdvancedLevel = true;
  static int currentYear = 11; //TODO: momentanes Jahr Festlegen
  static List<SmallGrade> smallGrades = [];
  static List<BigGrade> bigGrades = [];
  static Map<int,String> pointsToGrade = {
    15:"1+",
    14:"1",
    13:"1-",
    12:"2+",
    11:"2",
    10:"2-",
    9:"3+",
    8:"3",
    7:"3-",
    6:"4+",
    5:"4",
    4:"4-",
    3:"5+",
    2:"5",
    1:"5-",
    0:"6",
  };



  static void addGrade(Grade grade){
    if(grade.runtimeType == BigGrade) {
      bigGrades.add(grade as BigGrade);
    } else if(grade.runtimeType == SmallGrade) {
      smallGrades.add(grade as SmallGrade);
    }
    SaveSystem.saveGrades();
  }

  static List<SmallGrade> getSmallGradesBySubject(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]} ){
    List<SmallGrade> output = [];
    smallGrades.map((e) => {
      if(e.subject == subject)
        if(onlyCurrentYear = true && e.time.year != currentYear){}
        else{
          if(onlyPartsOfYear.contains(e.time.partOfYear))output.add(e)
        }
    });
    return output;
  }

  static List<BigGrade> getBigGradesBySubject(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]} ){
    List<BigGrade> output = [];
    bigGrades.map((e) => {if(e.subject == subject)
      if(onlyCurrentYear = true && e.time.year != currentYear){}
      else{
        if(onlyPartsOfYear.contains(e.time.partOfYear))output.add(e)
      }
    });
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

  static double getYearAverage(){
    double d = 0;
    int s = 0;
    for(Subject subject in TimeTable.subjects){
      double grade = getAverage(subject);
      if(grade != -1)s++;
      d += grade;
    }
    if(s == 0) return 0;
    return d / s;
  }

  static String PointToGrade(int points){
    String? grade = pointsToGrade[points];
    if(grade != null) {
      return grade;
    } else {
      return "Schwanz";
    }
  }

  static double getAverage(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]}){
    List<BigGrade> bigGradesSubject = getBigGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear,onlyPartsOfYear: onlyPartsOfYear);
    List<SmallGrade> smallGradesSubject = getSmallGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear,onlyPartsOfYear: onlyPartsOfYear);
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

      if(a == 0)return -1;
      return (smallGradeAverage + bigGradeAverage) / a;

    }
    else{
      double average = 0;
      bigGradesSubject.map((e) => average += e.value*2.0);
      smallGradesSubject.map((e) => average += e.value as double);

      if(smallGradesSubject.length + bigGradesSubject.length == 0) return -1;
      return average / (smallGradesSubject.length + bigGradesSubject.length);
    }
  }



}


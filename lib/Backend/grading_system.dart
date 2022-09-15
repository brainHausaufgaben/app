import 'package:brain_app/Backend/grade.dart';
import 'package:brain_app/Backend/linked_subject.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/main.dart';

class GradingSystem{
  static bool isAdvancedLevel = true;
  static int currentYear = 11;
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
  static Map<int,bool> yearsToLevel = {
    5 : false,
    6 : false,
    7 : false,
    8 : false,
    9 : false,
    10 : false,
    11 : true,
    12 : true,
    13 : true,

  };

  static Map yearsToLevelJsonEncodable(){
    Map<String,bool> map = {};
    yearsToLevel.forEach((key, value) => map[key.toString()] = value);
    return map;
  }

  static void addGrade(Grade grade){
    if(grade.runtimeType == BigGrade) {
      bigGrades.add(grade as BigGrade);
    } else if(grade.runtimeType == SmallGrade) {
      smallGrades.add(grade as SmallGrade);
    }
    SaveSystem.saveGrades();
  }
  static void removeGrade(Grade grade){
    if(grade.runtimeType == BigGrade) {
      if(bigGrades.contains(grade)) bigGrades.remove(grade as BigGrade);
    } else if(grade.runtimeType == SmallGrade) {
      if(smallGrades.contains(grade)) smallGrades.remove(grade as SmallGrade);
    }
    SaveSystem.saveGrades();
  }


  static void deleteSubject(Subject subject){
    for(SmallGrade smallGrade in getSmallGradesBySubject(subject)){
      removeGrade(smallGrade);
    }
    for(BigGrade bigGrade in getBigGradesBySubject(subject)){
      removeGrade(bigGrade);
    }

  }

  static void setAdvancedLevel(bool state){
    isAdvancedLevel = state;
    removeAllGrades();
    BrainApp.updatePreference("isAdvancedLevel", state);
    yearsToLevel[currentYear] = state;
    SaveSystem.saveAdvancedLevels();
  }

  static void setCurrentYear(int year) {
    currentYear = year;
    isAdvancedLevel = yearsToLevel[year]!;
    BrainApp.updatePreference("isAdvancedLevel", isAdvancedLevel);
    BrainApp.updatePreference("currentYear", year);
  }

  static void removeAllGrades( {bool onlyCurrentYear = true}){
    for(Subject subject in TimeTable.subjects){
      for(SmallGrade smallGrade in getSmallGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear)){
        removeGrade(smallGrade);
      }
      for(BigGrade bigGrade in getBigGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear)){
        removeGrade(bigGrade);
      }
    }


  }

  static List<SmallGrade> getSmallGradesBySubject(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]} ){
    List<SmallGrade> output = [];
    for(SmallGrade e in smallGrades){
      if(e.subject == subject) {
        if(onlyCurrentYear = true && e.time.year != currentYear){}
        else{
          if(onlyPartsOfYear.contains(e.time.partOfYear))output.add(e);
        }
      }
    }
    return output;
  }

  static List<BigGrade> getBigGradesBySubject(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]} ){
    List<BigGrade> output = [];
    for(BigGrade e in bigGrades){
      if(e.subject == subject) {
        if(onlyCurrentYear = true && e.time.year != currentYear){}
        else{
          if(onlyPartsOfYear.contains(e.time.partOfYear))output.add(e);
        }
      }
    }
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



  static double getYearAverage({List<int> onlyPartsOfYear = const [1,2,3]}){
    double d = 0;
    int s = 0;

    for(Subject subject in TimeTable.getAverageSubject()){
      double grade = getAverage(subject,onlyPartsOfYear: onlyPartsOfYear);
      if(grade != -1.0) {
        s++;
        d += grade;
      }
    }
    for(LinkedSubject linkedSubject in TimeTable.linkedSubjects){
      double grade = getLinkedAverage(linkedSubject,onlyPartsOfYear: onlyPartsOfYear);
      if(grade != -1.0) {
        s++;
        d += grade;
      }
    }
    if(s == 0) return -1;
    return  d / s;
  }

  static String PointToGrade(int points){
    String? grade = pointsToGrade[points];
    if(grade != null) {
      return grade;
    } else {
      return "-";
    }
  }


  static double getAverage(Subject subject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]}){
    List<BigGrade> bigGradesSubject = getBigGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear,onlyPartsOfYear: onlyPartsOfYear);
    List<SmallGrade> smallGradesSubject = getSmallGradesBySubject(subject,onlyCurrentYear: onlyCurrentYear,onlyPartsOfYear: onlyPartsOfYear);
    if(isAdvancedLevel){
      double bigGradeAverage = 0;
      double smallGradeAverage = 0;
      double a = 0;
      if(bigGradesSubject.isNotEmpty){
        for(BigGrade e in bigGradesSubject){
          bigGradeAverage += e.value;
        }
        bigGradeAverage /= bigGradesSubject.length.toDouble();
        a++;
      }
      if(smallGradesSubject.isNotEmpty){
        for(SmallGrade e in smallGradesSubject){
          smallGradeAverage += e.value;
        }
        smallGradeAverage /= smallGradesSubject.length.toDouble();
        a++;
      }

      if(a == 0)return -1.0;
      return (smallGradeAverage + bigGradeAverage) / a;

    }
    else{
      double average = 0;
      for(BigGrade e in bigGradesSubject){
        average += e.value*2.0;
      }

      for(SmallGrade e in smallGradesSubject){
        average += e.value.toDouble();
      }
      if(smallGradesSubject.length + bigGradesSubject.length == 0) return -1;
      return average / (smallGradesSubject.length + bigGradesSubject.length * 2);
    }
  }

  static double getLinkedAverage(LinkedSubject linkedSubject, {bool onlyCurrentYear = true,List<int> onlyPartsOfYear = const [1,2,3]}){
    double subjectAverages = 0.0;
    int a = 0;
    for(int i = 0; i < linkedSubject.subjects.length; i++){
      double average =  getAverage(linkedSubject.subjects[i],onlyCurrentYear: onlyCurrentYear,onlyPartsOfYear: onlyPartsOfYear);
      if(average < 0) continue;
      subjectAverages += average * (linkedSubject.evaluations[i] as double);
      a += linkedSubject.evaluations[i];
    }
    if(a == 0) return -1;
    return subjectAverages / (a as double);
  }
}


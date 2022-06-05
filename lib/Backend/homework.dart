import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class Homework {
  Subject subject;
  DateTime dueTime;
  String name;

  Homework(this.subject,this.dueTime,this.name){
    TimeTable.addHomework(this);

  }

  bool isDue(DateTime date){
    if(dueTime.year == date.year && dueTime.month == date.month && dueTime.day == date.day) {
      return true;
    } else {
      return false;
    }
  }

  Map toJSONEncodable(){
    Map<String,dynamic> map = new Map();
    List due = [];
    due.add(dueTime.year);
    due.add(dueTime.month);
    due.add(dueTime.day);


    map["name"] = name;
    map["dueTime"] = due;
    map["SubjectID"] = subject.id;
    return map;
  }



}
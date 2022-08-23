import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class Test {
  Subject subject;
  DateTime dueTime;
  String description;
  int notificationID = 0;

  Test(this.subject,this.dueTime,this.description){
    TimeTable.addTest(this);
  }

  void edit(Subject? newSubject, DateTime? newDueTime, String? newDescription){
    if(newSubject != null) subject = newSubject;
    if(newDueTime != null) dueTime = newDueTime;
    if(newDescription != null) description = newDescription;
    SaveSystem.saveTests();
  }

  bool isDue(DateTime date){
    if(dueTime.year == date.year && dueTime.month == date.month && dueTime.day == date.day) {
      return true;
    } else {
      return false;
    }
  }

  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    List due = [];
    due.add(dueTime.year);
    due.add(dueTime.month);
    due.add(dueTime.day);


    map["description"] = description;
    map["dueTime"] = due;
    map["SubjectID"] = subject.id;
    return map;
  }



}
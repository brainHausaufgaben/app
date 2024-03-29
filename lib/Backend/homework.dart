import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';

class Homework {
  Subject subject;
  DateTime dueTime;
  String name;
  int notificationID = 0;

  Homework(this.subject,this.dueTime,this.name){
    TimeTable.addHomework(this);
  }

  void edit(Subject? newSubject, DateTime? newDueTime, String? newName){
    if(newSubject != null) subject = newSubject;
    if(newDueTime != null) dueTime = newDueTime;
    if(newName != null) name = newName;
    SaveSystem.saveHomework();
    CustomNotifications.notificationsPlugin.cancel(notificationID);
    CustomNotifications.homeworkNotification(this);
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


    map["name"] = name;
    map["dueTime"] = due;
    map["SubjectID"] = subject.id;
    return map;
  }



}
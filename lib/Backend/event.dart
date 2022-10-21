import 'package:brain_app/Backend/notifications.dart';
import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/time_table.dart';

class Event{
  DateTime dueTime;
  String name;
  String description;


  Event(this.dueTime,this.name,this.description){
    addToTimeTable();

  }

  void addToTimeTable(){
    TimeTable.addEvent(this);
  }

  void edit(DateTime? newDueTime, String? newName,String? newDescription){
    if(newDescription != null) description = newDescription;
    if(newDueTime != null) dueTime = newDueTime;
    if(newName != null) name = newName;

    SaveSystem.saveEvents();
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
    map["description"] = description;
    return map;
  }



}

class Note extends Event{
  Note(dueTime,content) : super(dueTime, "null", content);

  @override
  void addToTimeTable() {
    TimeTable.addNote(this);
  }


  @override
  Map toJSONEncodable() {

    Map map = super.toJSONEncodable();
    map["isNote"] = true;
    return map;

  }


}
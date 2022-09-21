import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/todo_manager.dart';

class ToDoItem{
  String content;
  bool done = false;
  ToDoImportance importance;

  static final Map<ToDoImportance,int> importanceToInt = {
    ToDoImportance.low : 0,
    ToDoImportance.mid : 1,
    ToDoImportance.high : 2,
};

  ToDoItem(this.content,this.importance){
    ToDoManager.addToDo(this);
  }
  ToDoItem.load(this.content,this.importance,this.done){
    ToDoManager.addToDo(this);
  }

  void edit( String? newContent,ToDoImportance? newImportance){
    if(newContent != null)content = newContent;
    if(newImportance != null)importance = newImportance;
    SaveSystem.saveToDos();

  }

  Map toJSONEncodable(){
    Map<String,dynamic> map = {};
    map["content"] = content;
    map["done"] = done;
    map["importance"] = importanceToInt[importance];
    return map;
 }

}

enum ToDoImportance{
  low,
  mid,
  high,
}


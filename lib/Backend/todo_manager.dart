import 'package:brain_app/Backend/save_system.dart';
import 'package:brain_app/Backend/todo.dart';

class ToDoManager{
  static List<ToDoItem> toDos = [];

  static void addToDo(ToDoItem toDo){
    if(!toDos.contains(toDo))toDos.add(toDo);
    SaveSystem.saveToDos();
  }

  static void deleteToDo(ToDoItem toDo){
    if(toDos.contains(toDo))toDos.remove(toDo);
    SaveSystem.saveToDos();
  }

  static void changeToDoState(ToDoItem toDoItem, bool doneState){
    toDoItem.done = doneState;
    SaveSystem.saveToDos();
  }

  static List<ToDoItem> getDoneStateToDos(bool state){
    List<ToDoItem> out = [];
    for(ToDoItem toDo in toDos){
      if(toDo.done == state) out.add(toDo);
    }
    return out;
  }

  static ToDoImportance getHighestImportance() {
    ToDoImportance highestImportance = ToDoImportance.low;
    for(ToDoItem toDo in toDos){
      if(toDo.importance.index > highestImportance.index && !toDo.done) {
        highestImportance = toDo.importance;
      }
    }

    return highestImportance;
  }

  static List<ToDoItem> getImportanceToDos(ToDoImportance importance, {bool? state}){
    List<ToDoItem> out = [];
    List<ToDoItem> inp = [];
    if(state != null) {
      inp = getDoneStateToDos(state);
    } else {
      inp = toDos;
    }
    for(ToDoItem toDo in inp){
      if(toDo.importance == importance) out.add(toDo);
    }
    return out;
  }

  static List<ToDoItem> getSorted({bool? state}){
    List<ToDoItem> out = [];
    List st = [false,true];
    List im = [ToDoImportance.high,ToDoImportance.mid,ToDoImportance.low];
    if(state == null){
      for(bool s in st){
        for(ToDoImportance i in im){
          out.addAll(getImportanceToDos(i,state: s));
        }
      }
    }
    else{
      for(ToDoImportance i in im){
        out.addAll(getImportanceToDos(i));
      }
    }
    return out;
  }

  static List toDosToJSONEncodeble(){
    return toDos.map((item)
    {
      return item.toJSONEncodable();
    }
    ).toList();
  }


}
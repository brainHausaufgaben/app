
import 'package:brain_app/Backend/developer_options.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Backend/todo_manager.dart';
import 'package:localstorage/localstorage.dart';

import 'grading_system.dart';

class SaveSystem{
   static LocalStorage storage = LocalStorage("brain_app");


  static void saveSubjects(){
     storage.setItem("subjects", TimeTable.subjectsToJSONEncodeble());

  }

  static Future getSubjects() async{
      await storage.ready;
      print(storage.getItem("subjects"));
      return storage.getItem("subjects");
  }

   static void saveTimeTable(){
     storage.setItem("time_table", TimeTable.timeTableToJSONEncodable());
   }

   static getTimeTable(){
     return storage.getItem("time_table");
   }

   static void saveHomework(){
    storage.setItem("homework", TimeTable.homeworkToJSONEncodable());
   }
   static  getHomework(){
     return storage.getItem("homework");
   }

   static void saveEvents(){
    storage.setItem("events", TimeTable.eventsToJSONEncodable());

   }
   static  getEvents(){
     return storage.getItem("events");
   }

   static void saveTests(){
     storage.setItem("tests", TimeTable.testsToJSONEncodable());

   }
   static  getTests(){
     return storage.getItem("tests");
   }

   static void saveGrades(){
     storage.setItem("grades", GradingSystem.gradesToJSONEncodable());

   }
   static  getGrades(){
     return storage.getItem("grades");
   }
   static void saveDeveloperOptions(){
    print(DeveloperOptions.activatedCodes);
    storage.setItem("devs", DeveloperOptions.activatedCodes);
   }

   static getDeveloperOptions(){
    return storage.getItem("devs");
   }

   static void saveAdvancedLevels(){
    storage.setItem("advancedLevels", GradingSystem.yearsToLevelJsonEncodable());
   }

   static getAdvancedLevels(){
      return storage.getItem("advancedLevels");
   }

   static void saveLinkedSubjects(){
    storage.setItem("linkedSubjects", TimeTable.linkedSubjectsToJSONEncodable());

   }

   static getLinkedSubjects(){
     return storage.getItem("linkedSubjects");
   }

   static void saveToDos(){
     storage.setItem("toDos", ToDoManager.toDosToJSONEncodeble());
   }

   static getToDos(){
     return storage.getItem("toDos");
   }




}
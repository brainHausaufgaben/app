
import 'package:brain_app/Backend/time_table.dart';
import 'package:localstorage/localstorage.dart';

import 'grading_system.dart';

class SaveSystem{
   static LocalStorage storage = LocalStorage("brain_app");

  static void saveSubjects(){
     storage.setItem("subjects", TimeTable.subjectsToJSONEncodeble());

  }

  static Future getSubjects() async{
      await storage.ready;
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





}
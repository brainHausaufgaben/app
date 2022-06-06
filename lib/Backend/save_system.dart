
import 'package:brain_app/Backend/time_table.dart';
import 'package:localstorage/localstorage.dart';

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

   static  getTimeTable(){
     return storage.getItem("time_table");

   }

   static void saveHomework(){
    storage.setItem("homework", TimeTable.homeworkToJSONEncodable());
   }
   static  getHomework(){
     return storage.getItem("homework");
   }




}

import 'package:brain_app/Backend/time_table.dart';
import 'package:localstorage/localstorage.dart';

class SaveSystem{
   static LocalStorage storage = new LocalStorage("brain_app");

  static  void saveSubjects(){
     storage.setItem("subjects", TimeTable.subjectsToJSONEncodeable());
  }

  static  getSubjects(){
      return storage.getItem("subjects");
  }




}
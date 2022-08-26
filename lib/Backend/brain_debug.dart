import 'package:brain_app/Components/brain_toast.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import '../Components/navigation_helper.dart';

class BrainDebug{

  static LocalStorage localStorage = LocalStorage("brain_app_logs");

  static void log(dynamic text){
    if(BrainApp.preferences["showLogsOnScreen"]){
      BrainToast toast = BrainToast(text: text.toString());
      toast.show();
    }
    if (kDebugMode) {
      print(text);
    }
    if(BrainApp.preferences["saveLogs"]){
      localStorage.setItem(DateTime.now().toString(), text.toString());
    }



  }




}
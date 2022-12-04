import 'package:brain_app/Backend/brain_debug.dart';

Future<Map> parseSystemFile() async {
  BrainDebug.log("Error fetching the file! Platform specific import didn't work");
  throw Exception("Error fetching the file");
}

void saveFileToSystem(Map data) async {
  BrainDebug.log("Error fetching the file! Platform specific import didn't work");
  throw Exception("Error saving the file");
}
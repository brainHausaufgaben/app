import 'package:brain_app/Backend/Filesystem/filesystem_manager_failsafe.dart'
  if (dart.libary.io) 'package:brain_app/Backend/Filesystem/filesystem_manager_android.dart'
  if (dart.library.js) 'package:brain_app/Backend/Filesystem/filesystem_manager_web.dart';

abstract class FilesystemManager {
  static Future<Map> getFile() async {
    return await parseSystemFile();
  }

  static saveFile(Map data) {
    saveFileToSystem(data);
  }
}
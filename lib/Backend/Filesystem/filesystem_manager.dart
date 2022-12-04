import 'package:brain_app/Backend/Filesystem/filesystem_manager_android.dart'
  if (dart.library.html) 'package:brain_app/Backend/Filesystem/filesystem_manager_web.dart';

abstract class FilesystemManager {
  static Future<Map> getFile() async {
    return await parseSystemFile();
  }

  static saveFile(Map data) {
    saveFileToSystem(data);
  }
}
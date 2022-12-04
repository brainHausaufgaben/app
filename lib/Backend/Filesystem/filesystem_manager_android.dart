import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

Future<Map> parseSystemFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  Map decodedData = {};
  if (result != null) {
    String fileContents = String.fromCharCodes(await File(result.files.first.path!).readAsBytes());
    decodedData = jsonDecode(fileContents);
  }

  return decodedData;
}

void saveFileToSystem(Map data) async {
  FileSaver.instance.saveAs("export", Uint8List.fromList(jsonEncode(data).codeUnits), "brain", MimeType.OTHER);
}
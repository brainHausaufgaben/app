import 'dart:async';
import 'dart:convert';
import 'dart:html';

Future<Map> parseSystemFile() async {
  String? data;
  FileUploadInputElement uploadInput = FileUploadInputElement();
  uploadInput.click();

  Completer<Map> completer = Completer();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;

    if (files != null) {
      final File file = files.first;

      final FileReader reader = FileReader();

      reader.readAsText(file);
      await reader.onLoad.first;

      data = reader.result as String?;
      completer.complete(jsonDecode(data ?? ""));
    }
  });

  return completer.future;
}

void saveFileToSystem(Map data) async {
  AnchorElement()
    ..href = '${Uri.dataFromString(jsonEncode(data), mimeType: 'text/plain', encoding: utf8)}'
    ..download = "export.brain"
    ..style.display = 'none'
    ..click();
}
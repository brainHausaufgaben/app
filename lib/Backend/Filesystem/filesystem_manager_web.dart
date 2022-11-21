import 'dart:convert';
import 'dart:html';

Future<Map> parseSystemFile() async {
  FileUploadInputElement uploadInput = FileUploadInputElement();
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;

    if (files != null) {
      final File file = files.first;

      final FileReader reader = FileReader();

      reader.readAsText(file);
      await reader.onLoad.first;

      String? data = reader.result as String?;
      if (data != null) return jsonDecode(data);
    }
  });

  return {};
}

void saveFileToSystem(Map data) async {
  AnchorElement()
    ..href = '${Uri.dataFromString(jsonEncode(data), mimeType: 'text/plain', encoding: utf8)}'
    ..download = "export.brain"
    ..style.display = 'none'
    ..click();
}
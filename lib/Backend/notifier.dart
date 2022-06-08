import 'package:flutter/material.dart';

class Notifier with ChangeNotifier {
  void notifyOfChanges() {
    notifyListeners();
  }
}
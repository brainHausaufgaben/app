import 'package:flutter/material.dart';

// dummes fucking zeug nur um ein swatch zu machen was man braucht um material sachen zu färben
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class AppTheme {
  static Color mainColor = const Color(0xFF303540);
  static Color mainTextColor = const Color(0xFFFFFFFF);
  static BorderRadius borderRadius = BorderRadius.circular(10);
  static MaterialColor swatch = createMaterialColor(mainColor);
}
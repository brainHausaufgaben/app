import 'package:flutter/material.dart';

AppTheme currentTheme = AppTheme();

class AppTheme with ChangeNotifier {
  // Ich weiß nicht ob man die oberen 2 noch braucht also lass ich die zur sicherheit
  static Color mainColor = const Color(0xFF303540);
  static Color mainTextColor = const Color(0xFFFFFFFF);
  static BorderRadius borderRadius = BorderRadius.circular(10);

  static ThemeData currentTheme = monochromeTheme;
  // Test themes
  static ThemeData monochromeTheme = generateAppTheme(const Color(0xFF303540), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540));
  static ThemeData monochromeDarkTheme = generateAppTheme(const Color(0xFF6954A6), const Color(0xFF303540), const Color(0xFF484F5F), const Color(0xFFFFFFFF));
  static ThemeData keineAhnung = generateAppTheme(const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));

  void toggleTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}

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

ThemeData generateAppTheme(Color primaryColor, Color backgroundColor, Color secondaryBackground, Color textColor) {
  // Könnte besser sein, vielleicht geht das sogar mit einer custom class
  return ThemeData(
      primarySwatch: createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      backgroundColor: secondaryBackground,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: "Nunito",

      textTheme: TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.w800, fontSize:38, height: 0.6, color: textColor),
          headline2: TextStyle(fontWeight: FontWeight.w600, fontSize:24, height: 0.6, color: textColor),
          headline3: TextStyle(fontWeight: FontWeight.w400, fontSize:17,height: 1, color: textColor),
          subtitle1: TextStyle(fontWeight: FontWeight.w400, fontSize:20, color: textColor),
          bodyText1: TextStyle(fontWeight: FontWeight.w400, fontSize:15, color: textColor),
          bodyText2: TextStyle(fontWeight: FontWeight.w400, fontSize:15, color: secondaryBackground)
      )
  );
}
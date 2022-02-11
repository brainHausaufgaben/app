import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Braucht man für das toggleTheme und den ChangeNotifier
AppDesign currentDesign = AppDesign();

class AppDesign with ChangeNotifier {
  static bool darkMode = SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
  static DesignPackage current = Designs.monochromeTheme;

  AppDesign() {
    getDarkmode();
    getTheme();
  }

  void toggleTheme(String theme) async {
    if (theme == "monochromeTheme") {
      current = Designs.monochromeTheme;
    }
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", theme);
  }

  void toggleDarkMode() async {
    darkMode = !darkMode;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", darkMode);
  }

  void getDarkmode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool("darkMode") ?? darkMode;
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString("theme");
    if (theme != null) toggleTheme(theme);
  }
}

class Designs {
  // generateDesign(primaryColor, backgroundColor, boxBackground, textColor, contrastColor, overrideIconColor)
  static DesignPackage get monochromeTheme => AppDesign.darkMode ?
    generateDesign(const Color(0xFFFFFFFF), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229), false) :
    generateDesign(const Color(0xFF303540), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), false);

  static DesignPackage get greenTheme => AppDesign.darkMode ?
    generateDesign(const Color(0xFF82A914), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229), true) :
    generateDesign(const Color(0xFF82A914), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);

  static Map<String, DesignPackage> themeList = {
    "monochromeTheme" : monochromeTheme,
    "greenTheme" : greenTheme
  };
}

class DesignPackage {
  Color primaryColor;
  TextStyles textStyles;
  BoxStyle boxStyle;
  bool overrideIconColor;

  // Für material shit
  ThemeData themeData;

  DesignPackage({
    required this.primaryColor,
    required this.textStyles,
    required this.themeData,
    required this.boxStyle,
    required this.overrideIconColor
  });
}

class TextStyles {
  Color color;
  Color contrastColor;
  TextStyle pageHeadline;
  TextStyle pageSubtitle;
  TextStyle boxHeadline;
  TextStyle pointElementPrimary;
  TextStyle pointElementSecondary;
  TextStyle collapsibleText;
  TextStyle collapsibleTextContrast;
  TextStyle buttonText;
  TextStyle input;
  TextStyle tab;
  TextStyle alertDialogHeader;
  TextStyle alertDialogDescription;

  TextStyles({
    required this.color,
    required this.contrastColor,
    required this.pageHeadline,
    required this.pageSubtitle,
    required this.boxHeadline,
    required this.pointElementPrimary,
    required this.pointElementSecondary,
    required this.collapsibleText,
    required this.collapsibleTextContrast,
    required this.buttonText,
    required this.input,
    required this.tab,
    required this.alertDialogHeader,
    required this.alertDialogDescription
  });
}

class BoxStyle {
  BorderRadius borderRadius = BorderRadius.circular(10);
  BorderRadius inputBorderRadius = BorderRadius.circular(5);
  BoxShadow boxShadow;
  Color backgroundColor;

  BoxStyle({
    required this.backgroundColor,
    required this.boxShadow
  });
}

DesignPackage generateDesign(Color primaryColor, Color backgroundColor, Color boxBackground, Color textColor, Color contrastColor, bool overrideIconColor) {
  return DesignPackage(
      overrideIconColor: overrideIconColor,
      primaryColor: primaryColor,
      themeData: ThemeData(
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: "Nunito",
      ),
      textStyles: TextStyles(
        color: textColor,
        contrastColor: contrastColor,
        pageHeadline: TextStyle(fontWeight: FontWeight.w800, fontSize:36, height: 0.6, color: textColor),
        pageSubtitle: TextStyle(fontWeight: FontWeight.w400, fontSize:19, color: textColor),
        boxHeadline: TextStyle(fontWeight: FontWeight.w600, fontSize:20, height: 0.6, color: textColor),
        pointElementPrimary: TextStyle(fontWeight: FontWeight.w400, fontSize:16 ,height: 1, color: textColor.withAlpha(210)),
        pointElementSecondary: TextStyle(fontWeight: FontWeight.w400, fontSize:14, color: textColor.withAlpha(190)),
        collapsibleText: TextStyle(fontWeight: FontWeight.w400, fontSize:16, color: textColor),
        collapsibleTextContrast: TextStyle(fontWeight: FontWeight.w400, fontSize:16, color: contrastColor),
        buttonText: TextStyle(fontWeight: FontWeight.w600, fontSize:18, color: contrastColor),
        input: TextStyle(fontWeight: FontWeight.w400, fontSize:17, height: 1, color: textColor.withAlpha(210)),
        tab: TextStyle(fontWeight: FontWeight.w600, fontSize:18, color: textColor),
        alertDialogHeader: TextStyle(fontWeight: FontWeight.w600, fontSize:22, color: textColor),
        alertDialogDescription: TextStyle(fontWeight: FontWeight.w500, fontSize:17, color: textColor)
      ),
      boxStyle: BoxStyle(
          backgroundColor: boxBackground,
          boxShadow: BoxShadow(
              color: boxBackground.computeLuminance() > 0.5 ? const Color(0xFF303540).withOpacity(0.2) : Colors.white.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1)
        )
      )
  );
}

// -------------------------- Utility stuff --------------------------

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
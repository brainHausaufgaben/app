import 'dart:math';

import 'package:flutter/material.dart';

// Braucht man für das toggleTheme und den ChangeNotifier
AppDesign currentDesign = AppDesign();

class AppDesign with ChangeNotifier {
  static bool darkMode = false;
  static DesignPackage current = Designs.greenDarkTheme;

  void toggleTheme(DesignPackage designPackage) {
    current = designPackage;
    notifyListeners();
  }
}

class Designs {
  static DesignPackage monochromeTheme = generateDesign(
      const Color(0xFF303540), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF)
  );
  static DesignPackage weirdPurpleThemeIDK = generateDesign(
      const Color(0xFF442A43), const Color(0xFF16191E), const Color(0xFF20232C), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)
  );
  static DesignPackage purpleThemeButLightMode = generateDesign(
      const Color(0xFF58419F), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF)
  );
  static DesignPackage greenDarkTheme = generateDesign(
      const Color(0xFF82A914), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229)
  );

  static List<DesignPackage> themeList = [monochromeTheme, weirdPurpleThemeIDK, purpleThemeButLightMode, greenDarkTheme];

  static DesignPackage randomTheme() {
    Random random = Random();
    return themeList.elementAt(random.nextInt(themeList.length));
  }
}

class DesignPackage {
  Color primaryColor;
  TextStyles textStyles;
  BoxStyle boxStyle;

  // Für material shit
  ThemeData themeData;

  DesignPackage({
    required this.primaryColor,
    required this.textStyles,
    required this.themeData,
    required this.boxStyle
  });
}

class TextStyles {
  Color color;
  TextStyle pageHeadline;
  TextStyle pageSubtitle;
  TextStyle boxHeadline;
  TextStyle pointElementPrimary;
  TextStyle pointElementSecondary;
  TextStyle warningBoxText;

  TextStyles({
    required this.color,
    required this.pageHeadline,
    required this.pageSubtitle,
    required this.boxHeadline,
    required this.pointElementPrimary,
    required this.pointElementSecondary,
    required this.warningBoxText
  });
}

class BoxStyle {
  BorderRadius borderRadius = BorderRadius.circular(10);
  Color backgroundColor;

  BoxStyle({
    required this.backgroundColor
  });
}

DesignPackage generateDesign(Color primaryColor, Color backgroundColor, Color boxBackground, Color textColor, Color contrastColor) {
  return DesignPackage(
      primaryColor: primaryColor,
      themeData: ThemeData(
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: "Nunito",
      ),
      textStyles: TextStyles(
          color: textColor,
          pageHeadline: TextStyle(fontWeight: FontWeight.w800, fontSize:36, height: 0.6, color: textColor),
          pageSubtitle: TextStyle(fontWeight: FontWeight.w400, fontSize:19, color: textColor),
          boxHeadline: TextStyle(fontWeight: FontWeight.w600, fontSize:20, height: 0.6, color: textColor),
          pointElementPrimary: TextStyle(fontWeight: FontWeight.w400, fontSize:16 ,height: 1, color: textColor.withAlpha(210)),
          pointElementSecondary: TextStyle(fontWeight: FontWeight.w400, fontSize:15, color: textColor.withAlpha(190)), // Probably wrong
          warningBoxText: TextStyle(fontWeight: FontWeight.w400, fontSize:16, color: contrastColor)
      ),
      boxStyle: BoxStyle(
          backgroundColor: boxBackground
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
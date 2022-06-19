import 'package:flutter/material.dart';

class DesignPackage {
  Color primaryColor;
  TextStyles textStyles;
  BoxStyle boxStyle;
  bool overrideIconColor;

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
  TextStyle settingsSubMenu;

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
    required this.alertDialogDescription,
    required this.settingsSubMenu
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
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cardColor: boxBackground,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: "Nunito",
      ),
      textStyles: TextStyles(
          color: textColor,
          contrastColor: contrastColor,
          pageHeadline: TextStyle(fontWeight: FontWeight.w800, fontSize:36, height: 1, color: textColor),
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
          alertDialogDescription: TextStyle(fontWeight: FontWeight.w500, fontSize:17, color: textColor),
          settingsSubMenu: TextStyle(fontWeight: FontWeight.w500, fontSize:17, height: 1, color: textColor.withAlpha(210))
      ),
      boxStyle: BoxStyle(
          backgroundColor: boxBackground,
          boxShadow: BoxShadow(
              color: const Color(0xFF303540).withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1)
          )
      )
  );
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
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
    required this.overrideIconColor,
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
  TextStyle settingsSubMenuDescription;

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
    required this.settingsSubMenu,
    required this.settingsSubMenuDescription
  });
}

class BoxStyle {
  BorderRadius borderRadius = BorderRadius.circular(10);
  BorderRadius inputBorderRadius = BorderRadius.circular(5);
  BoxShadow boxShadow;
  Color backgroundColor;

  BoxStyle({
    required this.borderRadius,
    required this.backgroundColor,
    required this.boxShadow
  });
}

DesignPackage generateDesign(
    Color primaryColor,
    Color backgroundColor,
    Color boxBackground,
    Color textColor,
    Color contrastColor,
    bool overrideIconColor,
    [
      String font = "Inter",
      double sizeFactor = 1,
      bool removeBorderRadius = false
    ]) {

  return DesignPackage(
      overrideIconColor: overrideIconColor,
      primaryColor: primaryColor,
      themeData: ThemeData(
        brightness: backgroundColor.computeLuminance() < 0.5 ? Brightness.dark : Brightness.light,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cardColor: boxBackground,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        accentColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: font,
      ),
      textStyles: TextStyles(
          color: textColor,
          contrastColor: contrastColor,
          pageHeadline: TextStyle(fontWeight: FontWeight.w800, fontSize:36.0 * sizeFactor, height: 1, color: textColor),
          pageSubtitle: TextStyle(fontWeight: FontWeight.w600, fontSize:18.0 * sizeFactor, height: 1, color: textColor.withOpacity(0.8)),
          boxHeadline: TextStyle(fontWeight: FontWeight.w600, fontSize:19.0 * sizeFactor, height: 1, color: textColor),
          pointElementPrimary: TextStyle(fontWeight: FontWeight.w400, fontSize:15.0 * sizeFactor,height: 1, color: textColor.withOpacity(0.7)),
          pointElementSecondary: TextStyle(fontWeight: FontWeight.w400, fontSize:14.0 * sizeFactor, color: textColor.withOpacity(0.6)),
          collapsibleText: TextStyle(fontWeight: FontWeight.w500, fontSize:15.0 * sizeFactor, color: textColor),
          collapsibleTextContrast: TextStyle(fontWeight: FontWeight.w500, height: 1.3, fontSize:15.0 * sizeFactor, color: contrastColor),
          buttonText: TextStyle(fontWeight: FontWeight.w600, fontSize:17.0 * sizeFactor, color: contrastColor),
          input: TextStyle(fontWeight: FontWeight.w400, fontSize:16.0 * sizeFactor, height: 1, color: textColor.withAlpha(210)),
          tab: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0 * sizeFactor, color: textColor, fontFamily: font),
          alertDialogHeader: TextStyle(fontWeight: FontWeight.w600, fontSize:22.0 * sizeFactor, color: textColor),
          alertDialogDescription: TextStyle(fontWeight: FontWeight.w500, fontSize:17.0 * sizeFactor, color: textColor),
          settingsSubMenu: TextStyle(fontWeight: FontWeight.w500, fontSize:16.0 * sizeFactor, height: 1, color: textColor.withAlpha(210)),
          settingsSubMenuDescription: TextStyle(fontWeight: FontWeight.w400, fontSize:14.0 * sizeFactor, height: 1.3, color: textColor.withOpacity(0.6))
      ),
      boxStyle: BoxStyle(
        borderRadius: removeBorderRadius ? BorderRadius.zero : BorderRadius.circular(10),
        backgroundColor: boxBackground,
        boxShadow: BoxShadow(
            color: const Color(0xFF303540).withOpacity(0.2),
            blurRadius: 5,
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

String themeIconSvg = '''
  <svg width="158" height="251" viewBox="0 0 158 251" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M4.18408 11.157C4.18408 7.30585 7.30603 4.1839 11.1571 4.1839H146.117C149.968 4.1839 153.09 7.30585 153.09 11.157V239.719C153.09 243.57 149.968 246.692 146.117 246.692H11.1572C7.30604 246.692 4.18408 243.57 4.18408 239.719V11.157Z" fill="#F1F1F1"/>
    <path fill-rule="evenodd" clip-rule="evenodd" d="M11.1569 0H146.117C152.279 0 157.274 4.99511 157.274 11.1569V239.719C157.274 245.881 152.279 250.876 146.117 250.876H11.1569C4.99514 250.876 0 245.881 0 239.719V11.1569C0 4.99512 4.99512 0 11.1569 0ZM11.1569 4.18384C7.30579 4.18384 4.18384 7.30579 4.18384 11.1569V239.719C4.18384 243.57 7.3058 246.692 11.1569 246.692H146.117C149.968 246.692 153.09 243.57 153.09 239.719V11.1569C153.09 7.30579 149.968 4.18384 146.117 4.18384H11.1569Z" fill="#9B9B9B"/>
    <path d="M15.4238 34.0779H110.961V55.5164H15.4238V34.0779Z" fill="#303540"/>
    <path d="M15.4238 103.362H72.4367V112.78H15.4238V103.362Z" fill="#303540"/>
    <path d="M15.4238 13.9136H25.8091V24.0732H15.4238V13.9136Z" fill="#303540"/>
    <path d="M15.4238 69.7049C15.4238 67.3942 17.297 65.5211 19.6077 65.5211H135.362C137.672 65.5211 139.545 67.3942 139.545 69.7049V91.3512C139.545 93.6618 137.672 95.535 135.362 95.535H19.6077C17.297 95.535 15.4238 93.6618 15.4238 91.3512V69.7049Z" fill="#9B9B9B"/>
    <path d="M15.4238 120.862C15.4238 118.551 17.297 116.678 19.6077 116.678H135.362C137.672 116.678 139.545 118.551 139.545 120.862V156.8C139.545 159.111 137.672 160.984 135.362 160.984H19.6077C17.297 160.984 15.4238 159.111 15.4238 156.8V120.862Z" fill="white"/>
    <path d="M4.02832 225.973H153.09V238.324C153.09 242.946 149.344 246.692 144.723 246.692H12.396C7.77466 246.692 4.02832 242.946 4.02832 238.324V225.973Z" fill="white"/>
    <path d="M54.2759 225.973H102.997V246.692H54.2759V225.973Z" fill="#9B9B9B"/>
    <path d="M146.603 209.125C146.603 215.858 141.145 221.316 134.412 221.316C127.68 221.316 122.222 215.858 122.222 209.125C122.222 202.392 127.68 196.934 134.412 196.934C141.145 196.934 146.603 202.392 146.603 209.125Z" fill="#9B9B9B"/>
  </svg>
''';
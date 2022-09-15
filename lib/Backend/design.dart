import 'package:brain_app/Backend/brain_debug.dart';
import 'package:brain_app/Backend/theming_utilities.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class AppDesign {
  static AppColors colors = MonochromeDesign().lightVariant.colors;

  static TextStyles textStyles = TextStyles();
  static ThemeData themeData = MonochromeDesign().lightVariant.themeData;
  static BoxStyle boxStyle = BoxStyle();

  static double breakPointWidth = 900;

  static void toggleTheme(String theme) {
    DesignPackage package = BrainApp.preferences["darkMode"]
        ? Design.allDesigns[theme]!.darkVariant
        : Design.allDesigns[theme]!.lightVariant;
    setAttributes(package);
    BrainApp.updatePreference("design", theme);

    if (theme == "Monochrome") {
      setAccentColor();
    } else {
      BrainApp.notifier.notifyOfChanges();
    }
  }

  static void setAccentColor() {
    Color primaryColor = Color(BrainApp.preferences["overridePrimaryWith"]);

    setFromPackage(
        generateDesign(
            primaryColor,
            colors.background,
            colors.secondaryBackground,
            colors.text,
            primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white
        )
    );
  }

  static void setFromPackage(DesignPackage package) {
    setAttributes(package);
    BrainApp.notifier.notifyOfChanges();
  }

  static void setAttributes(DesignPackage package) {
    colors = package.colors;
    themeData = package.themeData;
  }

  static void toggleDarkMode() {
    BrainApp.updatePreference("darkMode", !BrainApp.preferences["darkMode"]);

    DesignPackage package = BrainApp.preferences["darkMode"]
        ? Design.allDesigns[BrainApp.preferences["design"]]!.darkVariant
        : Design.allDesigns[BrainApp.preferences["design"]]!.lightVariant;
    setAttributes(package);

    if (BrainApp.preferences["design"] == "Monochrome") {
      setAccentColor();
    } else {
      BrainApp.notifier.notifyOfChanges();
    }
  }
}

abstract class Design {
  static Map<String, Design> allDesigns = {
    "Monochrome" : MonochromeDesign(),
    "Just Golden" : JustGoldenDesign(),
    "Carrot Orange" : CarrotOrangeDesign(),
    "Pastel Red" : PastelRedDesign(),
    "Forest Green" : ForestGreenDesign(),
    "Ocean Blue" : OceanBlueDesign(),
    "Princess Pink" : PrincessPinkDesign(),
    "Jeremias Purple" : JeremiasPurpleDesign(),

  };

  DesignPackage get lightVariant;
  DesignPackage get darkVariant;
}

class MonochromeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF000000), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF2A2E38), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFFFFFFF), const Color(0xFF0D0E0F), const Color(0xFF1A1A1D), const Color(0xFFFFFFFF), const Color(0xFF212229));
}

class ForestGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF1A7343), const Color(0xFFEBF5EF), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF1A7343), const Color(0xFF0E1A12), const Color(0xFF15261B), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
}

class CarrotOrangeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFE86918), const Color(0xFFFAF0EE), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFDC5922), const Color(0xFF150B07), const Color(0xFF23150D), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
}

class PastelRedDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFC73053), const Color(0xFFFFF6F2), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFC73053), const Color(0xFF180A0F), const Color(0xFF2A1217), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
}

class OceanBlueDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF2A5AC5), const Color(0xFFF2F7FF), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF5661C7), const Color(0xFF0E0E21), const Color(0xFF1A1F41), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
}

class JeremiasPurpleDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFFF0E5FF), const Color(0xFFFAF7FF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFF140F1E), const Color(0xFF1F1A31), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
}

class JustGoldenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFC9A84C), const Color(0xFFECE6D2), const Color(0xFFF8F7E7), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFE1A74F), const Color(0xFF0A0A0A), const Color(0xFF1F1C1A), const Color(0xFFF5EAE0), const Color(0xFF1A1613));
}

class PrincessPinkDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFB733E5), const Color(0xFFF7EEFF), const Color(0xFFFFFDFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFB733E5), const Color(0xFF160C1A), const Color(0xFF281433), const Color(0xFFF5EAE0), const Color(0xFFF5EAE0));
}

class BlindnessDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF000000), const Color(0xFF000000), const Color(0xFF000000), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF000000), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0x00000000), const Color(0x00FFFFFF));
}

class CancerDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFFC03D3), const Color(0xFFebfc03), const Color(0xFFfc0303), const Color(0xFF03fcdf), const Color(0xFF3dfc03));
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFebfc03), const Color(0xFFfc0303), const Color(0xFFFC03D3), const Color(0xFF3dfc03), const Color(0xFF03fcdf));
}
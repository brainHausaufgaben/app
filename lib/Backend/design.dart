import 'package:flutter/material.dart';
import 'package:brain_app/main.dart';
import 'package:brain_app/Backend/theming_utilities.dart';

class AppDesign {
  static DesignPackage current = MonochromeDesign().lightVariant;
  static double breakPointWidth = 900;

  static void toggleTheme(String theme) {
    current = BrainApp.preferences["darkMode"]
        ? Design.allDesigns[theme]!.darkVariant
        : Design.allDesigns[theme]!.lightVariant;

    BrainApp.updatePreference("design", theme);
    BrainApp.notifier.notifyOfChanges();
  }

  static void toggleDarkMode() {
    BrainApp.updatePreference("darkMode", !BrainApp.preferences["darkMode"]);

    current = BrainApp.preferences["darkMode"]
        ? Design.allDesigns[BrainApp.preferences["design"]]!.darkVariant
        : Design.allDesigns[BrainApp.preferences["design"]]!.lightVariant;

    BrainApp.notifier.notifyOfChanges();
  }
}

abstract class Design {
  static Map<String, Design> allDesigns = {
    "Monochrome" : MonochromeDesign(),
    "Forest Green" : ForestGreenDesign(),
    "Carrot Orange" : CarrotOrangeDesign(),
    "Pastel Red" : PastelRedDesign(),
    "Ocean Blue" : OceanBlueDesign(),
    "Jeremias Purple" : JeremiasPurpleDesign(),
    "Just Golden" : JustGoldenDesign(),
    "Military Green" : MilitaryGreenDesign()
  };

  DesignPackage get lightVariant;
  DesignPackage get darkVariant;
}

class MonochromeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF303540), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), false);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFFFFFFF), const Color(0xFF0D0E0F), const Color(0xFF1A1A1D), const Color(0xFFFFFFFF), const Color(0xFF212229), false);
}

class ForestGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF82B063), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF82B063), const Color(0xFF0D0E0F), const Color(0xFF1A1A1D), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class CarrotOrangeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFE06E04), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFE06E04), const Color(0xFF0D0E0F), const Color(0xFF1A1A1D), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class PastelRedDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFEF6363), const Color(0xFFFFE8E8), const Color(0xFFFFF8F8), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFEF6363), const Color(0xFF331D1D), const Color(0xFF4B2D2D), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class OceanBlueDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF4B56B7), const Color(0xFFE7E7FF), const Color(0xFFF8F8FF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF5661C7), const Color(0xFF191B3A), const Color(0xFF262D5D), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), false);
}

class JeremiasPurpleDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFFF0E5FF), const Color(0xFFFAF7FF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFF261D38), const Color(0xFF382F59), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class MilitaryGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF455147), const Color(0xFFAABCAC), const Color(0xFFC9D4CA), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFA3BDA6), const Color(0xFF445346), const Color(0xFF637265), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class JustGoldenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFACA359), const Color(0xFFECE6D2), const Color(0xFFF8F7E7), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFB9AE51), const Color(0xFF35342A), const Color(0xFF464538), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}
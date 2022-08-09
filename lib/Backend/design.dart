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
    "Just Golden" : JustGoldenDesign(),
    "Carrot Orange" : CarrotOrangeDesign(),
    "Pastel Red" : PastelRedDesign(),
    "Forest Green" : ForestGreenDesign(),
    "Ocean Blue" : OceanBlueDesign(),
    "Jeremias Purple" : JeremiasPurpleDesign()
  };

  DesignPackage get lightVariant;
  DesignPackage get darkVariant;
}

class MonochromeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF000000), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF000000), const Color(0xFFFFFFFF), false);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFFFFFFF), const Color(0xFF0D0E0F), const Color(0xFF1A1A1D), const Color(0xFFFFFFFF), const Color(0xFF212229), false);
}

class ForestGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF1A7343), const Color(0xFFEBF5EF), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF1A7343), const Color(0xFF0E1A12), const Color(0xFF15261B), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class CarrotOrangeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFE86918), const Color(0xFFFAF0EE), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFE86918), const Color(0xFF1C110B), const Color(0xFF2F1E14), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class PastelRedDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFC73053), const Color(0xFFFFF2ED), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFC73053), const Color(0xFF26151A), const Color(0xFF3B2026), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class OceanBlueDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF2A5AC5), const Color(0xFFF2F7FF), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF5661C7), const Color(0xFF0E0E21), const Color(0xFF1A1F41), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), false);
}

class JeremiasPurpleDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFFF0E5FF), const Color(0xFFFAF7FF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFF261D38), const Color(0xFF382F59), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class JustGoldenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFC9A84C), const Color(0xFFECE6D2), const Color(0xFFF8F7E7), const Color(0xFF303540), const Color(0xFFFFFFFF), true, "CrimsonPro", 1.15, true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFE1A74F), const Color(0xFF0A0A0A), const Color(0xFF1F1C1A), const Color(0xFFF5EAE0), const Color(0xFF1A1613), true, "CrimsonPro", 1.15, true);
}
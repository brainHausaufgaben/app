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
    "Princess Pink" : PrincessPinkDesign(),
    "Jeremias Purple" : JeremiasPurpleDesign()
  };

  DesignPackage get lightVariant;
  DesignPackage get darkVariant;
}

class MonochromeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF000000), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF000000), const Color(0xFFFFFFFF));
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
      generateDesign(const Color(0xFFC73053), const Color(0xFFFFF2ED), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF));
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
      generateDesign(const Color(0xFFB733E5), const Color(0xFF160C1A), const Color(0xFF281433), const Color(0xFFF5EAE0), const Color(0xFF1A1613));
}
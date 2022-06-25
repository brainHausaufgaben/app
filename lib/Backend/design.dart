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
    "Poison Green" : PoisonGreenDesign(),
    "Carrot Orange" : CarrotOrangeDesign(),
    "Pastel Red" : PastelRedDesign(),
    "Ocean Blue" : OceanBlueDesign(),
    "Jeremias Purple" : JeremiasPurpleDesign(),
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
      generateDesign(const Color(0xFFFFFFFF), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229), false);
}

class PoisonGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF82A914), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF82A914), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class CarrotOrangeDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFE06E04), const Color(0xFFF1F1F1), const Color(0xFFFFFFFF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFE06E04), const Color(0xFF15161D), const Color(0xFF1C1D24), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}

class PastelRedDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFFEF6363), const Color(0xFFF6D2D2), const Color(0xFFF6E5E5), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFEF6363), const Color(0xFF4B2B2B), const Color(0xFF5F3A3A), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class OceanBlueDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF3F4AA7), const Color(0xFFCDCFF6), const Color(0xFFDFE0F5), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF3F4AA7), const Color(0xFF23295C), const Color(0xFF313873), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), false);
}

class JeremiasPurpleDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFFD7CBFB), const Color(0xFFE9E1FF), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFF6249AB), const Color(0xFF2D2648), const Color(0xFF382F59), const Color(0xFFFFFFFF), const Color(0xFFFFFFFF), true);
}

class MilitaryGreenDesign extends Design {
  @override
  DesignPackage get lightVariant =>
      generateDesign(const Color(0xFF455147), const Color(0xFFAABCAC), const Color(0xFFC9D4CA), const Color(0xFF303540), const Color(0xFFFFFFFF), true);
  @override
  DesignPackage get darkVariant =>
      generateDesign(const Color(0xFFA3BDA6), const Color(0xFF445346), const Color(0xFF637265), const Color(0xFFFFFFFF), const Color(0xFF212229), true);
}


import 'package:shared_preferences/shared_preferences.dart';

// TODO: zentralisiertes speichern für einstellungen
class Preferences {
  static SharedPreferences? prefs;
  static bool mediaBox = true;

  static void fetchInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String? fetchTheme() {
    fetchInstance();
    return prefs?.getString("theme");
  }

  static bool? fetchDarkmode() {
    fetchInstance();
    return prefs?.getBool("darkMode");
  }

  static bool? fetchCollapsed() {
    fetchInstance();
    return prefs?.getBool("collapsed");
  }

  static void fetchMediaBoxState() {
    fetchInstance();
    mediaBox = prefs!.getBool("mediaBox")!;
  }
}
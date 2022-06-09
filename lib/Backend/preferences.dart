import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? prefs;

  static void fetchInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void setString(String key, String value) {
    fetchInstance();
    prefs?.setString(key, value);
  }

  static String getString(String key) {
    fetchInstance();
    return prefs?.getString(key) ?? "";
  }

  static void setBool(String key, bool value) {
    fetchInstance();
    prefs?.setBool(key, value);
  }

  static bool getBool(String key) {
    fetchInstance();
    return prefs?.getBool(key) ?? false;
  }
}
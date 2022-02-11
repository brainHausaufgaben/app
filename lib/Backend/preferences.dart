import 'package:brain_app/Backend/theming.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences? prefs;

  void fetchInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? fetchTheme() {
    fetchInstance();
    return prefs?.getString("theme");
  }

  bool? fetchCollapsed() {
    fetchInstance();
    return prefs?.getBool("collapsed");
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setTheme(bool value) async =>
      _prefs.setBool('dark theme', value);

  static bool isDarkTheme() => _prefs.getBool('dark theme') ?? true;
}

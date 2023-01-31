import 'package:flutter/material.dart';
import 'package:organise_me/preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDark = Preferences.isDarkTheme();
  bool get isDark => _isDark;

  setdarkTheme(bool value) {
    _isDark = value;
    Preferences.setTheme(value);
    notifyListeners();
  }

  isDarkTheme() {
    _isDark = Preferences.isDarkTheme();
    notifyListeners();
  }
}

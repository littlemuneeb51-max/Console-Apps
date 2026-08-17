import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider(this._prefs)
      : _themeMode = (_prefs.getBool(StorageKeys.themeMode) ?? false)
            ? ThemeMode.dark
            : ThemeMode.light;

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setBool(StorageKeys.themeMode, isDark);
    notifyListeners();
  }
}

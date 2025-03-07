import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  bool _isLoaded = false; // Track initialization status

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  bool get isLoaded => _isLoaded;

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool('darkMode');

    _themeMode = isDark == null
        ? ThemeMode.system
        : (isDark ? ThemeMode.dark : ThemeMode.light);

    _isLoaded = true; // Mark as initialized
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs.setBool('darkMode', isDark);
    notifyListeners();
  }
}

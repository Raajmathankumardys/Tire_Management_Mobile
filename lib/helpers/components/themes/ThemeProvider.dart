// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeMode? _themeMode;
//   bool _isLoaded = false; // Track initialization status
//
//   ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
//   bool get isLoaded => _isLoaded;
//
//   Future<void> loadTheme() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isDark = prefs.getBool('darkMode');
//
//     _themeMode = isDark == null
//         ? ThemeMode.system
//         : (isDark ? ThemeMode.dark : ThemeMode.light);
//
//     _isLoaded = true; // Mark as initialized
//     notifyListeners();
//   }
//
//   void toggleTheme(bool isDark) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     prefs.setBool('darkMode', isDark);
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// States
abstract class ThemeState {}

class ThemeLoadingState extends ThemeState {}

class ThemeLoadedState extends ThemeState {
  final ThemeMode themeMode;
  ThemeLoadedState(this.themeMode);
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeLoadingState()) {
    on<LoadThemeEvent>(_loadTheme);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  Future<void> _loadTheme(
      LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool("isDarkMode") ?? false;
    emit(ThemeLoadedState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> _toggleTheme(
      ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = !(state is ThemeLoadedState &&
        (state as ThemeLoadedState).themeMode == ThemeMode.dark);
    await prefs.setBool("isDarkMode", isDarkMode);
    emit(ThemeLoadedState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }
}

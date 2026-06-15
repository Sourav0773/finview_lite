import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider {
  final ValueNotifier<ThemeMode> themeNotifier;

  AppThemeProvider({required bool isDarkModeInitially}) : themeNotifier = ValueNotifier<ThemeMode>(isDarkModeInitially ? ThemeMode.dark : ThemeMode.light);

  bool get isDarkMode => themeNotifier.value == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
      await prefs.setBool('is_dark_mode', true);
    } else {
      themeNotifier.value = ThemeMode.light;
      await prefs.setBool('is_dark_mode', false);
    }
  }

  void dispose() => themeNotifier.dispose();
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeController() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if the preference exists and handle different types
      if (prefs.containsKey(_themePreferenceKey)) {
        // Try to get as bool first
        try {
          _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
        } catch (e) {
          // If it fails, it might be stored as a string
          final stringValue = prefs.getString(_themePreferenceKey);
          if (stringValue != null) {
            _isDarkMode = stringValue.toLowerCase() == 'true';
          }

          // Convert to proper bool for future use
          await prefs.setBool(_themePreferenceKey, _isDarkMode);
        }
      } else {
        _isDarkMode = false;
      }

      notifyListeners();
    } catch (e) {
      // Fallback to default if any error occurs
      _isDarkMode = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePreferenceKey, _isDarkMode);
    } catch (e) {
      // Handle error silently
    }

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themePreferenceKey, _isDarkMode);
      } catch (e) {
        // Handle error silently
      }

      notifyListeners();
    }
  }
}

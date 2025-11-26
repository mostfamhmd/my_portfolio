import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    // Load theme asynchronously without blocking
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        final newMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        );
        if (_themeMode != newMode) {
          _themeMode = newMode;
          // Use SchedulerBinding to ensure we're not in the build phase
          SchedulerBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
    } catch (e) {
      // Silently handle errors
    }
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      // If system, toggle to light
      setThemeMode(ThemeMode.light);
    }
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // This will be determined by the system, but we can't access it here
      // The MaterialApp will handle this
      return false; // Default fallback
    }
    return _themeMode == ThemeMode.dark;
  }
}


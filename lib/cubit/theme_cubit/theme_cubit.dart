import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkMode: false)) { // ✅ Changed to false (Light Mode)
    _loadTheme();
  }

  // Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('theme_mode') ?? false; // ✅ Default false
      emit(ThemeState(isDarkMode: isDark));
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    try {
      final newMode = !state.isDarkMode;
      emit(ThemeState(isDarkMode: newMode));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme_mode', newMode);
    } catch (e) {
      print('Error toggling theme: $e');
    }
  }

  // Set specific theme
  Future<void> setTheme(bool isDark) async {
    try {
      emit(ThemeState(isDarkMode: isDark));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme_mode', isDark);
    } catch (e) {
      print('Error setting theme: $e');
    }
  }
}
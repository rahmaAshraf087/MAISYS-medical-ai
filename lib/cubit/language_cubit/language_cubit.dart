import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'language_code';

  LanguageCubit() : super(const LanguageState(languageCode: 'en', isArabic: false)) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString(_languageKey) ?? 'en';
      emit(LanguageState(
        languageCode: langCode,
        isArabic: langCode == 'ar',
      ));
    } catch (e) {
      print('Error loading language: $e');
    }
  }

  Future<void> toggleLanguage() async {
    try {
      final newLang = state.isArabic ? 'en' : 'ar';
      emit(LanguageState(
        languageCode: newLang,
        isArabic: newLang == 'ar',
      ));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, newLang);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  Future<void> setLanguage(String langCode) async {
    try {
      emit(LanguageState(
        languageCode: langCode,
        isArabic: langCode == 'ar',
      ));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, langCode);
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  String getFontFamily() {
    return state.isArabic ? 'IBM_Plex_Sans_Arabic' : 'Outfit';
  }
}
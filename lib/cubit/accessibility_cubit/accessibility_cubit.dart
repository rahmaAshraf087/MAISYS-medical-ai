import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accessibility_state.dart';

class AccessibilityCubit extends Cubit<AccessibilityState> {
  static const String _textScaleKey = 'text_scale_factor';

  AccessibilityCubit() : super(const AccessibilityState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scale = prefs.getDouble(_textScaleKey) ?? 1.0;
      emit(AccessibilityState(textScaleFactor: scale));
    } catch (e) {
      print('Error loading accessibility: $e');
    }
  }

  Future<void> setTextScale(double scale) async {
    try {
      emit(state.copyWith(textScaleFactor: scale));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey, scale);
    } catch (e) {
      print('Error setting text scale: $e');
    }
  }
}
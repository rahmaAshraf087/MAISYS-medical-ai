import 'package:flutter/material.dart';
import 'color_manager.dart';

class AppTheme {
  static ThemeData darkTheme(String fontFamily, bool highContrast) {
    final bgColor = highContrast ? ColorManager.highContrastBackground : ColorManager.kohly;
    final textColor = highContrast ? ColorManager.highContrastText : Colors.white;
    final primaryColor = highContrast ? ColorManager.highContrastPrimary : ColorManager.primaryBlue;
    final surfaceColor = highContrast ? Color(0xFF1A1A1A) : ColorManager.loginContainer;


    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColor,
      fontFamily: fontFamily,

      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: textColor, fontFamily: fontFamily),
        displayLarge: TextStyle(color: textColor, fontFamily: fontFamily),
      ),

      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: surfaceColor,
        onSurface: textColor,
      ),
    );
  }

  static ThemeData lightTheme(String fontFamily, bool highContrast) {
    if (highContrast) {
      // High contrast overrides light theme
      return darkTheme(fontFamily, true);
    }

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: ColorManager.lightPrimaryBlue,
      scaffoldBackgroundColor: ColorManager.lightBackground,
      fontFamily: fontFamily,

      textTheme: TextTheme(
        bodyLarge: TextStyle(color: ColorManager.lightTextPrimary, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: ColorManager.lightTextSecondary, fontFamily: fontFamily),
        displayLarge: TextStyle(color: ColorManager.lightTextPrimary, fontFamily: fontFamily),
      ),

      colorScheme: ColorScheme.light(
        primary: ColorManager.lightPrimaryBlue,
        surface: ColorManager.lightContainer,
        onSurface: ColorManager.lightTextPrimary,
      ),
    );
  }
}
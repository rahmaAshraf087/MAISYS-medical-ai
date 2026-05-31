

import 'package:flutter/material.dart';
import 'package:maisys/theme/style_helper.dart';
import 'color_manager.dart';

class DarkTheme{
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorManager.kohly,
    colorScheme: ColorScheme.fromSeed(
      //background for Scaffold,container
      seedColor: ColorManager.kohly,
      brightness: Brightness.dark,
      surface: ColorManager.loginContainer,//container login
      secondary:ColorManager.welcomecontainer,//container welcome
      secondaryContainer: ColorManager.cardscontainer,//container cards
      tertiary: ColorManager.filledtextfield,//filled textformfield

    ),
    textTheme: TextTheme(
      //styleHelper for text
      headlineLarge: TextStyles.font28primarybluebold,//Welcome to Maisys
      titleMedium: TextStyles.font18white600w,//card title
      bodyMedium: TextStyles.font16gray600w,//desc cards
      bodySmall: TextStyles.font12lightgray400w,//footer text
      titleSmall: TextStyles.font20whitebold,//Email & password title
      bodyLarge: TextStyles.font14white400w, //hintText Style
      labelSmall: TextStyles.font14whitebold, //yellow warning text &don't have an account
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.buttonBackground,
      ),
    ),
  );

}

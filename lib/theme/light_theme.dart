

import 'package:flutter/material.dart';
import 'package:maisys/theme/style_helper.dart';

import 'color_manager.dart';

class LightTheme2{
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorManager.white,
    colorScheme: ColorScheme.fromSeed(
      //background for Scaffold,container
      seedColor: ColorManager.white,
      brightness: Brightness.light,
      surface: ColorManager.loginContainerWhite,//container login
      secondary: ColorManager.containerWelcomegray,//container welcome
      secondaryContainer: ColorManager.cardCapagrey,//container cards
      tertiary: ColorManager.filledTextFormFieldwhite,//filled textformfield

    ),
    textTheme: TextTheme(
      //styleHelper for text
      headlineLarge: TextStyles.font28primarybluebold,//Welcome to Maisys
      titleMedium: TextStyles.font18titleBlack600w,//card title
      bodyMedium: TextStyles.font16descBlack600w,//desc cards
      bodySmall: TextStyles.font12footerblack400w,//footer text
      titleSmall: TextStyles.font20titleBlackbold,//Email & password title
      bodyLarge: TextStyles.font14footerblack400w, //hintText Style
      labelSmall: TextStyles.font14whitebold, //yellow warning text &don't have an account
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.buttonBackground,
      ),
    ),
  );

}

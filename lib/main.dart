import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/accessibility_cubit/accessibility_state.dart';
import 'package:maisys/cubit/language_cubit/language_state.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/accessibility_cubit/accessibility_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_state.dart';
import 'package:maisys/screens/splash_screen.dart';
import 'package:maisys/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => AccessibilityCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, langState) {
              return BlocBuilder<AccessibilityCubit, AccessibilityState>(
                builder: (context, accessState) {
                  final fontFamily = context.read<LanguageCubit>().getFontFamily();

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MAISYS',
                    theme: themeState.isDarkMode
                        ? AppTheme.darkTheme(fontFamily, false)
                        : AppTheme.lightTheme(fontFamily, false),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(accessState.textScaleFactor),
                        ),
                        child: child!,
                      );
                    },
                    home: const SplashScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
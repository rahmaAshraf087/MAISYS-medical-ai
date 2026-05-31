import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_state.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';

class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isArabic = state.isArabic;

        return GestureDetector(
          onTap: () {
            context.read<LanguageCubit>().toggleLanguage();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  isArabic ? 'عربي' : 'Arabic',
                  style: TextStyle(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: isArabic ? 'IBM_Plex_Sans_Arabic' : 'Outfit',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
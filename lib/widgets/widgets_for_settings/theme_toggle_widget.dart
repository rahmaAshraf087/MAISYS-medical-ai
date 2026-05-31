import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_state.dart';
import 'package:maisys/theme/color_manager.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;

        return GestureDetector(
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
              shape: BoxShape.circle,
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
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Color(0xFF5B21B6),
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
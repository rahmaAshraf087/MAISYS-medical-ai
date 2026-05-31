import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/theme/color_manager.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (showBack)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),

            // Logo or Title
            if (title == null) ...[
              if (showBack) SizedBox(width: 15),
              Image.asset(
                isDark
                    ? "assets/svgs/appbar_logo/WhiteLogo.png"
                    : "assets/svgs/appbar_logo/BlackLogo.png",
                width: 120,
                height: 40,
              ),
            ] else ...[
              if (showBack) SizedBox(width: 15),
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  ),
                ),
              ),
            ],

            Spacer(),

            // Drawer icon (CircleAvatar)
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: isDark
                      ? Color(0xFF2D3E50)
                      : ColorManager.lightBorder,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
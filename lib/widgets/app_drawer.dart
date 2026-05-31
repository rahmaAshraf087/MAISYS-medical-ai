import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/overviews/overviewscreen.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/screens/profile_screen.dart';
import 'package:maisys/screens/settings_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = '';
  bool isLoading = true;
  //File? _profileImage;
  String? _profilePictureBase64;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final result = await ApiService.getUserProfile();
      if (!mounted) return;

      setState(() {
        isLoading = false;
        if (result['success'] == true) {
          final user = result['user'];
          final first = user['firstName'] ?? '';
          final last = user['lastName'] ?? '';
          final fullName = '$first $last'.trim();
          userName = fullName.contains('@') ? '' : fullName;

          // ✅ الصورة من الـ backend
          final pic = user['profilePicture'];
          if (pic != null && pic.toString().isNotEmpty) {
            _profilePictureBase64 = pic.toString();
          }
        }
      });
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }
  Future<void> _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Drawer(
      backgroundColor:
      isDark ? ColorManager.loginContainer : ColorManager.lightContainer,
      child: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? ColorManager.kohly : ColorManager.lightBorder,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Color(0xFF2D3E50)
                        : ColorManager.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                    backgroundImage: _profilePictureBase64 != null
                        ? MemoryImage(base64Decode(
                      _profilePictureBase64!.contains(',')
                          ? _profilePictureBase64!.split(',').last
                          : _profilePictureBase64!,
                    ))
                        : null,
                    child: _profilePictureBase64 == null
                        ? Icon(Icons.person, size: 40,
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                        : null,
                  ),
                  SizedBox(height: 15),
                  // Name
                  isLoading
                      ? SizedBox(
                    width: 120,
                    height: 16,
                    child: LinearProgressIndicator(
                      backgroundColor: isDark
                          ? Color(0xFF2D3E50)
                          : ColorManager.lightBorder,
                      color: isDark
                          ? ColorManager.primaryBlue
                          : ColorManager.lightPrimaryBlue,
                    ),
                  )
                      : Text(
                    userName.isNotEmpty
                        ? userName
                        : (isArabic
                        ? 'اكتب اسمك في البروفايل'
                        : 'Write your name in Profile'),
                    style: userName.isNotEmpty
                        ? TextStyles.font20whitebold.copyWith(
                      color: isDark
                          ? Colors.white
                          : ColorManager.lightTextPrimary,
                    )
                        : TextStyles.font14whitebold.copyWith(
                      color: isDark
                          ? Colors.white54
                          : ColorManager.lightTextSecondary,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // ===== MENU ITEMS =====
            _buildDrawerItem(
              icon: Icons.home_outlined,
              label: isArabic ? 'الرئيسية' : 'Home',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => OverviewScreen()),
                      (route) => false,
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.person_outline,
              label: isArabic ? 'الملف الشخصي' : 'Profile',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),

            _buildDrawerItem(
              icon: Icons.settings_outlined,
              label: isArabic ? 'الإعدادات' : 'Settings',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
              },
            ),

            Spacer(),

            Divider(
              color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              thickness: 1,
            ),

            // ===== LOGOUT =====
            _buildDrawerItem(
              icon: Icons.logout,
              label: isArabic ? 'تسجيل الخروج' : 'Logout',
              isDark: isDark,
              color: Colors.red,
              onTap: _logout,
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ??
        (isDark ? Colors.white : ColorManager.lightTextPrimary);

    return ListTile(
      leading: Icon(icon, color: itemColor, size: 24),
      title: Text(
        label,
        style: TextStyles.font16white600w.copyWith(color: itemColor),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
    );
  }
}
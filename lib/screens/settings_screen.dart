import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/accessibility_cubit/accessibility_cubit.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/widgets/app_drawer.dart';
import 'package:maisys/widgets/app_header.dart';
import 'package:maisys/widgets/footer_widget.dart';
import 'package:maisys/widgets/medical_disclaimer_widget.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:maisys/cubit/accessibility_cubit/accessibility_state.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor:
      isDark ? ColorManager.kohly : ColorManager.lightBackground,
      endDrawer: AppDrawer(), // ✅
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: isArabic ? 'الإعدادات' : 'Settings'),

            // Main Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40),

                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          isArabic ? 'الإعدادات' : 'Settings',
                          style: TextStyles.font28primarybluebold.copyWith(
                            color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Language Section
                    _buildLanguageSection(context, isDark, isArabic),

                    SizedBox(height: 20),

                    // Theme Section
                    _buildThemeSection(context, isDark, isArabic),

                    SizedBox(height: 20),

                    // Notifications Section (Disabled for now)
                    _buildNotificationsSection(isDark, isArabic),

                    SizedBox(height: 20),

                    // Accessibility Section
                    _buildAccessibilitySection(context, isDark, isArabic),

                    SizedBox(height: 20),

                    // Logout Button
                    ElevatedButton(
                      onPressed: () async {
                        await ApiService.logout();
                        if (!context.mounted) return ;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Login()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
                    ),

                    SizedBox(height: 20),

                    // About MAISYS Section
                    _buildAboutSection(isDark, isArabic),

                    SizedBox(height: 40),

                    // Footer
                    FooterWidget(),

                    SizedBox(height: 20),

                    // Medical Disclaimer
                    MedicalDisclaimerWidget(),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top Header
  /*Widget _buildTopHeader(BuildContext context, bool isDark) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MAISYS Logo
          Image.asset(
            isDark
                ? "assets/svgs/appbar_logo/WhiteLogo.png"
                : "assets/svgs/appbar_logo/BlackLogo.png",
            width: 120,
            height: 40,
          ),

          // Top Navigation Icons
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _buildNavIcon(Icons.arrow_back, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OverviewScreen()),
                  );
                },
                child: _buildNavIcon(Icons.home_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreChatScreen()),
                  );
                },
                child: _buildNavIcon(Icons.chat_bubble_outline, false, isDark),
              ),
              SizedBox(width: 10),
              _buildNavIcon(Icons.settings_outlined, true, isDark),
              SizedBox(width: 10),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
*/
  /*Widget _buildNavIcon(IconData icon, bool isActive, bool isDark) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
            : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
        size: 18,
      ),
    );
  }
*/
  // Language Section
  Widget _buildLanguageSection(BuildContext context, bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'اللغة' : 'Language',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageButton(context, 'English', !isArabic, isDark),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _buildLanguageButton(context, 'العربية', isArabic, isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String language, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        final langCode = language == 'English' ? 'en' : 'ar';
        context.read<LanguageCubit>().setLanguage(langCode);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
              : (isDark ? Color(0xFF0D1620) : ColorManager.lightBorder),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
            width: 1,
          ),
        ),
        child: Text(
          language,
          textAlign: TextAlign.center,
          style: TextStyles.font14whitebold.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : ColorManager.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  // Theme Section
  Widget _buildThemeSection(BuildContext context, bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'المظهر' : 'Theme',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildThemeButton(
                    context,
                    isArabic ? 'الوضع الفاتح' : 'Light Mode',
                    Icons.light_mode,
                    false,
                    isDark,
                    isArabic,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _buildThemeButton(
                    context,
                    isArabic ? 'الوضع الداكن' : 'Dark Mode',
                    Icons.dark_mode,
                    true,
                    isDark,
                    isArabic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton(
      BuildContext context,
      String label,
      IconData icon,
      bool isDarkTheme,
      bool currentIsDark,
      bool isArabic,
      ) {
    bool isSelected = currentIsDark == isDarkTheme;
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().setTheme(isDarkTheme);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? (currentIsDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
              : (currentIsDark ? Color(0xFF0D1620) : ColorManager.lightBorder),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (currentIsDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                : (currentIsDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isArabic) ...[
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (currentIsDark ? Colors.white70 : ColorManager.lightTextSecondary),
                size: 18,
              ),
              SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyles.font14whitebold.copyWith(
                color: isSelected
                    ? Colors.white
                    : (currentIsDark ? Colors.white70 : ColorManager.lightTextSecondary),
              ),
            ),
            if (isArabic) ...[
              SizedBox(width: 8),
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (currentIsDark ? Colors.white70 : ColorManager.lightTextSecondary),
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Notifications Section (Disabled)
  Widget _buildNotificationsSection(bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'الإشعارات' : 'Notifications',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              isArabic ? 'قريباً' : 'Coming Soon',
              style: TextStyles.font14whitebold.copyWith(
                color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Accessibility Section
  Widget _buildAccessibilitySection(BuildContext context, bool isDark, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'إمكانية الوصول' : 'Accessibility',
                style: TextStyles.font20whitebold.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
              SizedBox(height: 20),

              // ✅ Text Size Slider فقط
              Text(
                isArabic ? 'حجم النص' : 'Text Size',
                style: TextStyles.font14whitebold.copyWith(
                  color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('A',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white54
                            : ColorManager.lightTextSecondary,
                      )),
                  Expanded(
                    child: BlocBuilder<AccessibilityCubit, AccessibilityState>(
                      builder: (context, state) {
                        return Slider(
                          value: state.textScaleFactor,
                          min: 0.8,
                          max: 1.4,
                          divisions: 6,
                          activeColor: isDark
                              ? ColorManager.primaryBlue
                              : ColorManager.lightPrimaryBlue,
                          inactiveColor: isDark
                              ? Color(0xFF2D3E50)
                              : ColorManager.lightBorder,
                          onChanged: (val) {
                            context
                                .read<AccessibilityCubit>()
                                .setTextScale(val);
                          },
                        );
                      },
                    ),
                  ),
                  Text('A',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark
                            ? Colors.white54
                            : ColorManager.lightTextSecondary,
                      )),
                ],
              ),
              // Preview text
              BlocBuilder<AccessibilityCubit, AccessibilityState>(
                builder: (context, state) {
                  return Center(
                    child: Text(
                      isArabic ? 'معاينة حجم النص' : 'Text size preview',
                      style: TextStyle(
                        fontSize: 14 * state.textScaleFactor,
                        color: isDark
                            ? Colors.white70
                            : ColorManager.lightTextSecondary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
    );
  }

  /* Widget _buildAccessibilityToggle(
      BuildContext context,
      String label,
      bool value,
      VoidCallback onTap,
      bool isDark,
      bool isArabic,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isArabic) Text(
          label,
          style: TextStyles.font16white600w.copyWith(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                  : (isDark ? Color(0xFF0D1620) : Colors.transparent),
              shape: BoxShape.circle,
              border: Border.all(
                color: value
                    ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                    : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
                width: 2,
              ),
            ),
            child: value
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        if (isArabic) Text(
          label,
          style: TextStyles.font16white600w.copyWith(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
        ),
      ],
    );
  }*/

  // About Section
  Widget _buildAboutSection(bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'حول MAISYS' : 'About MAISYS',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 15),
            _buildInfoRow(
              isArabic ? 'الإصدار' : 'Version',
              '1.0.0',
              isDark,
              isArabic,
            ),
            SizedBox(height: 10),
            Text(
              isArabic
                  ? 'نظام الذكاء الاصطناعي الطبي للحصول على إرشادات صحية موثوقة'
                  : 'Medical AI System for Trusted Health Guidance',
              style: TextStyles.font14whitebold.copyWith(
                color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                fontWeight: FontWeight.normal,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isArabic) ...[
          Text(
            label,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ] else ...[
          Text(
            value,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
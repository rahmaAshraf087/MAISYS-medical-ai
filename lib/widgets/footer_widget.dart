import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/screens/terms_policy_screen.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().state.isArabic;
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: ColorManager.loginContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Description
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Image.asset(
                  isDark ? "assets/svgs/appbar_logo/WhiteLogo.png"
                      : "assets/svgs/appbar_logo/BlackLogo.png",
                  width: 120,
                  height: 40,
                ),
                SizedBox(height: 15),
                Text(
                  isArabic
                      ? 'نظام الذكاء الاصطناعي الطبي\nللإرشاد الصحي الموثوق'
                      : 'Medical AI System for Trusted Health\nGuidance',
                  style: TextStyles.font12lightgray400w,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ],
            ),
          ),

          SizedBox(width: 30),

          // Features Column
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'المميزات' : 'FEATURES',
                  style: TextStyles.font12lightgray400w.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: isArabic ? 0 : 1.2,
                  ),
                ),
                SizedBox(height: 15),
                _buildFooterLink(isArabic ? 'الشات بوت الطبي' : 'Medical Chatbot'),
                _buildFooterLink(isArabic ? 'تفاعل الأدوية' : 'Drug Interactions'),
                _buildFooterLink(isArabic ? 'شرح التحاليل' : 'Lab Test Explainer'),
                _buildFooterLink(isArabic ? 'مساعد البحث' : 'Research Assistant'),
              ],
            ),
          ),

          SizedBox(width: 30),

          // Legal Column
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'قانوني' : 'LEGAL',
                  style: TextStyles.font12lightgray400w.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: isArabic ? 0 : 1.2,
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TermsPolicyScreen())),
                  child: _buildFooterLink(
                      isArabic ? 'إخلاء المسؤولية الطبية' : 'Medical Disclaimer'),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TermsPolicyScreen())),
                  child: _buildFooterLink(
                      isArabic ? 'سياسة الخصوصية' : 'Privacy Policy'),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TermsPolicyScreen())),
                  child: _buildFooterLink(
                      isArabic ? 'شروط الخدمة' : 'Terms of Service'),
                ),
                _buildFooterLink(
                    isArabic ? 'حدود الذكاء الاصطناعي' : 'AI Limitations'),
              ],
            ),
          ),

          SizedBox(width: 30),

          // Contact Column
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تواصل معنا' : 'CONTACT',
                  style: TextStyles.font12lightgray400w.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: isArabic ? 0 : 1.2,
                  ),
                ),
                SizedBox(height: 15),
                _buildFooterLink('support@maisys.health'),
                _buildFooterLink(isArabic ? 'مصادر البيانات' : 'Data Sources'),
                _buildFooterLink('v1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyles.font12lightgray400w,
      ),
    );
  }
}
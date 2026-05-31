import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/overviews/activityscreen.dart';
import 'package:maisys/overviews/medicaltoolsscreen.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:maisys/widgets/app_drawer.dart';
import 'package:maisys/widgets/app_header.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int selectedTabIndex = 0;

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
            AppHeader(), // ✅
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _buildHeroSection(isDark ,isArabic),
                    SizedBox(height: 30),
                    _buildTabNavigation(isDark, isArabic),
                    SizedBox(height: 30),
                    _buildBottomDisclaimer(isDark, isArabic),
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

  /*Widget _buildTopHeader(BuildContext context, bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            isDark
                ? "assets/svgs/appbar_logo/WhiteLogo.png"
                : "assets/svgs/appbar_logo/BlackLogo.png",
            width: 120,
            height: 40,
          ),
          _buildTopNavIcons(context, isDark),
        ],
      ),
    );
  }*/

  /*Widget _buildTopNavIcons(BuildContext context, bool isDark) {
    return Row(
      children: [
        _buildNavIcon(Icons.home_outlined, false, isDark),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => PreChatScreen())),
          child: _buildNavIcon(Icons.chat_bubble_outline, false, isDark),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => SettingsScreen())),
          child: _buildNavIcon(Icons.settings_outlined, false, isDark),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ProfileScreen())),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.primaryBlue
                  : ColorManager.lightPrimaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
*/
 /* Widget _buildNavIcon(IconData icon, bool isActive, bool isDark) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
            : (isDark ? ColorManager.loginContainer : ColorManager.lightBorder),
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
  Widget _buildHeroSection(bool isDark, bool isArabic) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.loginContainer : ColorManager.lightContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1A2332) : ColorManager.lightBorder,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.favorite,
              color: isDark
                  ? ColorManager.primaryBlue
                  : ColorManager.lightPrimaryBlue,
              size: 35,
            ),
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: isArabic ? 'مساعدك الطبي ' : 'Your Medical ',
                  style: TextStyles.font28primarybluebold.copyWith(
                    color: isDark
                        ? Colors.white
                        : ColorManager.lightTextPrimary,
                  ),
                ),
                TextSpan(
                  text: isArabic ? 'بالذكاء الاصطناعي' : 'AI Assistant',
                  style: TextStyles.font28primarybluebold.copyWith(
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            isArabic
                ? 'احصل على معلومات صحية موثوقة مدعومة بمصادر طبية معتمدة'
                : 'Get trusted health information powered by verified medical sources',
            textAlign: TextAlign.center,
            style: TextStyles.font16gray600w.copyWith(
              color: isDark ? ColorManager.gray : ColorManager.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(bool isDark, bool isArabic) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MedicalToolsScreen())),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.loginContainer
                      : ColorManager.lightBorder,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services_outlined,
                        color: isDark
                            ? Colors.white
                            : ColorManager.lightTextPrimary,
                        size: 18),
                    SizedBox(width: 8),
                    Text(
                      isArabic ? 'الأدوات الطبية' : 'Medical Tools',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark
                            ? Colors.white
                            : ColorManager.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ActivityScreen())),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.loginContainer
                      : ColorManager.lightBorder,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history,
                        color: isDark
                            ? Colors.white
                            : ColorManager.lightTextPrimary,
                        size: 18),
                    SizedBox(width: 8),
                    Text(
                      isArabic ? 'النشاط' : 'Activity',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark
                            ? Colors.white
                            : ColorManager.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*Widget _buildTabButton(
      String title, int index, IconData icon, bool isDark) {
    bool isActive = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => MedicalToolsScreen()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ActivityScreen()));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                ? ColorManager.primaryBlue
                : ColorManager.lightPrimaryBlue)
                : (isDark
                ? ColorManager.loginContainer
                : ColorManager.lightBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  size: 18),
              SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.font14whitebold.copyWith(
                  fontSize: 13,
                  color:
                  isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/
  /* Widget _buildQuickActionsSection(
      BuildContext context, bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إجراءات سريعة' : 'Quick Actions',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
          SizedBox(height: 15),
          _buildQuickActionCard(
            title: isArabic ? 'الشات بوت الطبي' : 'Medical Chatbot',
            subtitle: isArabic
                ? 'اسأل أسئلة صحية بأمان مع مصادر طبية موثقة'
                : 'Ask health-related questions safely with cited sources from verified medical databases',
            icon: Icons.chat_bubble_outline,
            badge: isArabic ? 'ذكاء اصطناعي' : 'AI-Powered',
            isDark: isDark,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PreChatScreen())),
          ),
          SizedBox(height: 15),
          _buildQuickActionCard(
            title: isArabic ? 'فحص تفاعل الأدوية' : 'Drug Interaction Checker',
            subtitle: isArabic
                ? 'افحص سلامة الدواء والتفاعلات واحصل على معلومات الجرعات'
                : 'Check medication safety, interactions, and get dosage information',
            icon: Icons.medical_services_outlined,
            badge: isArabic ? 'مهم' : 'Critical',
            badgeColor: Colors.orange,
            isDark: isDark,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => DrugInteractionScreen())),
          ),
          SizedBox(height: 15),
          _buildQuickActionCard(
            title: isArabic ? 'شرح نتائج التحاليل' : 'Lab Test Explainer',
            subtitle: isArabic
                ? 'افهم نتائج تحاليل الدم والمختبر بوضوح'
                : 'Understand your blood work and laboratory test results clearly',
            icon: Icons.science_outlined,
            isDark: isDark,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => LabTestUploadScreen())),
          ),
        ],
      ),
    );
  }*/

 /* Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? ColorManager.loginContainer : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1A2332) : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isDark
                      ? ColorManager.primaryBlue
                      : ColorManager.lightPrimaryBlue,
                  size: 25),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyles.font16white600w.copyWith(
                            color: isDark
                                ? Colors.white
                                : ColorManager.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor ?? ColorManager.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: TextStyles.font12lightgray400w.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: isDark
                          ? ColorManager.lightGray
                          : ColorManager.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: isDark ? ColorManager.gray : ColorManager.lightTextSecondary,
                size: 16),
          ],
        ),
      ),
    );
  }*/




  Widget _buildBottomDisclaimer(bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (!isArabic)
            Icon(Icons.info_outline,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
                size: 16),
          if (!isArabic) SizedBox(width: 8),
          Expanded(
            child: RichText(
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isArabic
                        ? 'تقدم MAISYS معلومات طبية لأغراض تعليمية فقط. '
                        : 'MAISYS provides medical information for educational purposes only. ',
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: isDark
                          ? ColorManager.lightGray
                          : ColorManager.lightTextSecondary,
                    ),
                  ),
                  TextSpan(
                    text: isArabic
                        ? 'لا تشخص أو تعالج أو تحل محل الاستشارة الطبية المتخصصة.'
                        : 'It does not diagnose, treat, or replace professional medical advice.',
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: isDark
                          ? ColorManager.lightGray
                          : ColorManager.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isArabic) SizedBox(width: 8),
          if (isArabic)
            Icon(Icons.info_outline,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
                size: 16),
        ],
      ),
    );
  }
}
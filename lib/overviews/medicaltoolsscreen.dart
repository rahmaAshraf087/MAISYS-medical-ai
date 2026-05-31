import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/chatscreen/pre_chat_screen.dart';
import 'package:maisys/medical_tools/drug_interaction/drug_interaction_screen.dart';
import 'package:maisys/medical_tools/lab_test/lab_test_upload_screen.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_upload_screen.dart';
import 'package:maisys/medical_tools/symptom_checker/symptom_checker_question1_screen.dart';
import 'package:maisys/widgets/app_drawer.dart';
import 'package:maisys/widgets/app_header.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class MedicalToolsScreen extends StatelessWidget {
  const MedicalToolsScreen({super.key});

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
            AppHeader(title: isArabic ? 'الأدوات الطبية' : 'Medical Tools'), // ✅
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _buildToolsGrid(context, isDark, isArabic),
                    SizedBox(height: 40),
                    // ✅ حذفنا Footer و MedicalDisclaimer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          Image.asset(
            isDark
                ? "assets/svgs/appbar_logo/WhiteLogo.png"
                : "assets/svgs/appbar_logo/BlackLogo.png",
            width: 120,
            height: 40,
          ),

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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: _buildNavIcon(Icons.settings_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
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
  Widget _buildToolsGrid(BuildContext context, bool isDark, bool isArabic) {
    final tools = [
      {
        'icon': Icons.chat_bubble_outline,
        'color': Color(0xFF00B4D8),
        'title': isArabic ? 'الشات بوت الطبي' : 'Medical Chatbot',
        'route': PreChatScreen(),
      },
      {
        'icon': Icons.psychology_outlined,
        'color': Color(0xFF7C3AED),
        'title': isArabic ? 'فاحص الأعراض' : 'Symptom Checker',
        'route': SymptomCheckerQuestion1Screen(),
      },
      {
        'icon': Icons.medication_outlined,
        'color': Color(0xFFEF4444),
        'title': isArabic ? 'تفاعل الأدوية' : 'Drug Interaction',
        'route': DrugInteractionScreen(),
      },
      {
        'icon': Icons.biotech_outlined,
        'color': Color(0xFF10B981),
        'title': isArabic ? 'شرح التحاليل' : 'Lab Test Explainer',
        'route': LabTestUploadScreen(),
      },
      {
        'icon': Icons.article_outlined,
        'color': Color(0xFFF59E0B),
        'title': isArabic ? 'مساعد البحث' : 'Research Assistant',
        'route': ResearchAssistantUploadScreen(),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          final color = tool['color'] as Color;

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => tool['route'] as Widget),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Color(0xFF1E2A3A)
                    : ColorManager.lightContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Color(0xFF2D3E50)
                      : ColorManager.lightBorder,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Icon بدون background
                  Icon(
                    tool['icon'] as IconData,
                    color: color,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      tool['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark
                            ? Colors.white
                            : ColorManager.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
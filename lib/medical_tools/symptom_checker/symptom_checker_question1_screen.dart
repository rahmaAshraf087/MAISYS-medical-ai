import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/symptom_checker/symptom_checker_question2_screen.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class SymptomCheckerQuestion1Screen extends StatefulWidget {
  const SymptomCheckerQuestion1Screen({super.key});

  @override
  State<SymptomCheckerQuestion1Screen> createState() => _SymptomCheckerQuestion1ScreenState();
}

class _SymptomCheckerQuestion1ScreenState extends State<SymptomCheckerQuestion1Screen> {
  String? selectedSymptom;

  final symptomsEn = [
    'Headache', 'Fever', 'Cough', 'Fatigue',
    'Shortness of Breath', 'Chest Pain', 'Nausea', 'Dizziness',
  ];

  final symptomsAr = [
    'صداع', 'حمى', 'سعال', 'إرهاق',
    'ضيق في التنفس', 'ألم في الصدر', 'غثيان', 'دوخة',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor: isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context, isDark, isArabic),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'فاحص الأعراض' : 'Symptom Checker',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text('1', style: TextStyles.font20whitebold.copyWith(
                            color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          )),
                          Text(' / 6', style: TextStyles.font16white600w.copyWith(
                            color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                          )),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Text(
                      isArabic ? 'ما هو العرض الرئيسي؟' : 'What is your primary symptom?',
                      style: TextStyles.font20whitebold.copyWith(
                        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: 20),

                    ...List.generate(symptomsEn.length, (i) => _buildSymptomCard(
                      symptomsEn[i],
                      isArabic ? symptomsAr[i] : symptomsEn[i],
                      isDark,
                      isArabic,
                    )),

                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedSymptom == null ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SymptomCheckerQuestion2Screen(
                                primarySymptom: selectedSymptom!,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                        ),
                        child: Text(
                          isArabic ? 'التالي' : 'Next',
                          style: TextStyles.font16white600w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isDark, bool isArabic) {
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
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
          SizedBox(width: 15),
          Text(
            isArabic ? 'فاحص الأعراض' : 'Symptom Checker',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomCard(String symptomKey, String displayName,
      bool isDark, bool isArabic) {
    final isSelected = selectedSymptom == symptomKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSymptom = symptomKey; // نحفظ الـ English key دايماً
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
              : (isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (!isArabic) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white38 : ColorManager.lightBorder),
                    width: 2,
                  ),
                  color: isSelected ? Colors.white24 : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              SizedBox(width: 15),
            ],
            Expanded(
              child: Text(
                displayName,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
            ),
            if (isArabic) ...[
              SizedBox(width: 15),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white38 : ColorManager.lightBorder),
                    width: 2,
                  ),
                  color: isSelected ? Colors.white24 : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/drug_interaction/drug_interaction_result_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class DrugInteractionScreen extends StatefulWidget {
  const DrugInteractionScreen({super.key});

  @override
  State<DrugInteractionScreen> createState() => _DrugInteractionScreenState();
}

class _DrugInteractionScreenState extends State<DrugInteractionScreen> {
  final List<String> medications = [];
  final TextEditingController medicationController = TextEditingController();
  bool isLoading = false;
  String _selectedLanguage = 'en';

  @override
  void dispose() {
    medicationController.dispose();
    super.dispose();
  }

  void _addMedication() {
    if (medicationController.text.trim().isEmpty) return;

    if (medications.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .read<LanguageCubit>()
                .state
                .isArabic
                ? 'الحد الأقصى 5 أدوية'
                : 'Maximum 5 medications allowed',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      medications.add(medicationController.text.trim());
      medicationController.clear();
    });
  }

  void _removeMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  Future<void> _checkInteractions() async {
    final isArabic = context
        .read<LanguageCubit>()
        .state
        .isArabic;

    setState(() => isLoading = true);

    final result = await ApiService.checkDrugInteractions(
      medications: medications,
      language: _selectedLanguage, // ✅
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DrugInteractionResultScreen(
                medications: medications,
                interactions: List<Map<String, dynamic>>.from(
                    result['interactions'] ?? []),
                summary: result['summary'] ?? '',
                warnings: List<String>.from(result['warnings'] ?? []),
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ??
              (isArabic ? 'فشل الفحص' : 'Check failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context
        .watch<ThemeCubit>()
        .state
        .isDarkMode;
    final isArabic = context
        .watch<LanguageCubit>()
        .state
        .isArabic;

    return Scaffold(
      backgroundColor: isDark ? ColorManager.kohly : ColorManager
          .lightBackground,
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
                      isArabic
                          ? 'فحص تفاعل الأدوية'
                          : 'Drug Interaction Checker',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager
                            .lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      isArabic
                          ? 'أدخل الأدوية التي تتناولها للتحقق من التفاعلات'
                          : 'Enter medications you are taking to check for interactions',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark ? Colors.white70 : ColorManager
                            .lightTextSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    SizedBox(height: 30),

                    Text(
                      isArabic ? 'إضافة دواء' : 'Add Medication',
                      style: TextStyles.font20whitebold.copyWith(
                        color: isDark ? Colors.white : ColorManager
                            .lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: isDark ? Color(0xFF0D1620) : ColorManager
                                  .lightBorder,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Color(0xFF2D3E50) : ColorManager
                                    .lightBorder,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: medicationController,
                              style: TextStyle(
                                color: isDark ? Colors.white : ColorManager
                                    .lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: isArabic
                                    ? 'اسم الدواء'
                                    : 'Medication name',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white54 : ColorManager
                                      .lightTextSecondary,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _addMedication(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: _addMedication,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ColorManager.primaryBlue
                                  : ColorManager.lightPrimaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    if (medications.isNotEmpty) ...[
                      Text(
                        isArabic
                            ? 'الأدوية المضافة (${medications.length})'
                            : 'Added Medications (${medications.length})',
                        style: TextStyles.font20whitebold.copyWith(
                          color: isDark ? Colors.white : ColorManager
                              .lightTextPrimary,
                        ),
                      ),

                      SizedBox(height: 15),

                      ...medications
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final medication = entry.value;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF1E2A3A) : ColorManager
                                .lightContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Color(0xFF2D3E50) : ColorManager
                                  .lightBorder,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isDark
                                      ? ColorManager.primaryBlue
                                      : ColorManager.lightPrimaryBlue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.medication,
                                  color: isDark
                                      ? ColorManager.primaryBlue
                                      : ColorManager.lightPrimaryBlue,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  medication,
                                  style: TextStyles.font16white600w.copyWith(
                                    color: isDark ? Colors.white : ColorManager
                                        .lightTextPrimary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeMedication(index),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 30),
                      // ✅ Language Toggle
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isArabic
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'لغة الرد' : 'Response Language',
                              style: TextStyles.font16white600w.copyWith(
                                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedLanguage = 'en'),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _selectedLanguage == 'en'
                                            ? (isDark
                                            ? ColorManager.primaryBlue
                                            : ColorManager.lightPrimaryBlue)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue,
                                        ),
                                      ),
                                      child: Text(
                                        'English',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.font14whitebold.copyWith(
                                          color: _selectedLanguage == 'en'
                                              ? Colors.white
                                              : (isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedLanguage = 'ar'),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _selectedLanguage == 'ar'
                                            ? (isDark
                                            ? ColorManager.primaryBlue
                                            : ColorManager.lightPrimaryBlue)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue,
                                        ),
                                      ),
                                      child: Text(
                                        'العربية',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.font14whitebold.copyWith(
                                          color: _selectedLanguage == 'ar'
                                              ? Colors.white
                                              : (isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: medications.length < 2 || isLoading
                              ? null
                              : _checkInteractions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? ColorManager.primaryBlue
                                : ColorManager.lightPrimaryBlue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: (isDark ? ColorManager
                                .primaryBlue : ColorManager.lightPrimaryBlue),
                          ),
                          child: isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            isArabic ? 'فحص التفاعلات' : 'Check Interactions',
                            style: TextStyles.font16white600w,
                          ),
                        ),
                      ),

                      if (medications.length < 2) ...[
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            isArabic
                                ? 'أضف دواءين على الأقل'
                                : 'Add at least 2 medications',
                            style: TextStyles.font14whitebold.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ],

                    if (medications.isEmpty) ...[
                      SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 80,
                              color: isDark ? Colors.white24 : ColorManager
                                  .lightBorder,
                            ),
                            SizedBox(height: 20),
                            Text(
                              isArabic
                                  ? 'لم تتم إضافة أدوية بعد'
                                  : 'No medications added yet',
                              style: TextStyles.font16white600w.copyWith(
                                color: isDark ? Colors.white54 : ColorManager
                                    .lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
            isArabic ? 'تفاعل الأدوية' : 'Drug Interaction',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

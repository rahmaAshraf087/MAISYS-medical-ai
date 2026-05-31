import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/lab_test/lab_test_result_screen.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class LabTestProcessingScreen extends StatefulWidget {
  // ✅ أضفنا الـ parameters اللي هتيجي من الشاشة السابقة
  final String? imageBase64;
  final String? imageUrl;

  const LabTestProcessingScreen({
    super.key,
    this.imageBase64,
    this.imageUrl,
  });

  @override
  State<LabTestProcessingScreen> createState() => _LabTestProcessingScreenState();
}

class _LabTestProcessingScreenState extends State<LabTestProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ نبدأ التحليل تلقائياً
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    // ✅ انتظر 2 ثانية (simulation)
    await Future.delayed(Duration(seconds: 2));

    // ✅ هنا المفروض تعملي API call
    // لكن دلوقتي هنعمل Mock Data للاختبار

    final mockResult = {
      'success': true,
      'extractedText': 'Sample lab report text:\n\nHemoglobin: 14.5 g/dL\nWBC: 7,500 cells/μL\nPlatelets: 250,000 cells/μL',
      'analysis': {
        'markers': [
          {
            'name': 'Hemoglobin',
            'value': 14.5,
            'unit': 'g/dL',
            'status': 'normal',
            'interpretation': 'Within normal range'
          },
          {
            'name': 'White Blood Cells',
            'value': 7500,
            'unit': 'cells/μL',
            'status': 'normal',
            'interpretation': 'Healthy immune system'
          },
        ],
        'summary': 'All test results are within normal ranges. No immediate concerns detected.',
        'urgency': 'routine'
      }
    };

    if (!mounted) return;

    // ✅ انتقل لشاشة النتائج
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LabTestResultScreen(
          extractedText: mockResult['extractedText'] as String,
          analysis: mockResult['analysis'] as Map<String, dynamic>,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor: isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                  strokeWidth: 4,
                ),

                SizedBox(height: 40),

                Text(
                  isArabic ? 'جاري تحليل النتائج...' : 'Analyzing Results...',
                  style: TextStyles.font28primarybluebold.copyWith(
                    color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                Text(
                  isArabic
                      ? 'نقوم باستخراج النص من الصورة وتحليل النتائج بواسطة الذكاء الاصطناعي'
                      : 'Extracting text from image and analyzing results using AI',
                  style: TextStyles.font16white600w.copyWith(
                    color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStep(isArabic ? '1. استخراج النص' : '1. Text Extraction', true, isDark, isArabic),
                      SizedBox(height: 15),
                      _buildStep(isArabic ? '2. تحليل المؤشرات' : '2. Analyzing Markers', true, isDark, isArabic),
                      SizedBox(height: 15),
                      _buildStep(isArabic ? '3. توليد التقرير' : '3. Generating Report', false, isDark, isArabic),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String text, bool completed, bool isDark, bool isArabic) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: completed
                ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
            shape: BoxShape.circle,
          ),
          child: completed
              ? Icon(Icons.check, color: Colors.white, size: 18)
              : SizedBox(),
        ),
        SizedBox(width: 15),
        Text(
          text,
          style: TextStyles.font16white600w.copyWith(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
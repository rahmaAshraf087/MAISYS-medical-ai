import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class SymptomCheckerQuestion3Screen extends StatefulWidget {
  final String primarySymptom;
  final String duration;

  const SymptomCheckerQuestion3Screen({
    super.key,
    required this.primarySymptom,
    required this.duration,
  });

  @override
  State<SymptomCheckerQuestion3Screen> createState() => _SymptomCheckerQuestion3ScreenState();
}

class _SymptomCheckerQuestion3ScreenState extends State<SymptomCheckerQuestion3Screen> {
  double severityLevel = 5.0;

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
                          Text('3', style: TextStyles.font20whitebold.copyWith(
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
                      isArabic ? 'ما مدى شدة ${widget.primarySymptom}؟' : 'How severe is your ${widget.primarySymptom}?',
                      style: TextStyles.font20whitebold.copyWith(
                        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      isArabic ? '(1 = خفيف، 10 = شديد جداً)' : '(1 = Mild, 10 = Very Severe)',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    SizedBox(height: 40),

                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            severityLevel.toInt().toString(),
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: _getSeverityColor(severityLevel, isDark),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _getSeverityLabel(severityLevel, isArabic),
                            style: TextStyles.font16white600w.copyWith(
                              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                            ),
                          ),
                          SizedBox(height: 30),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: _getSeverityColor(severityLevel, isDark),
                              inactiveTrackColor: (isDark ? Colors.white : ColorManager.lightBorder),
                              thumbColor: _getSeverityColor(severityLevel, isDark),
                              overlayColor: _getSeverityColor(severityLevel, isDark),
                              trackHeight: 8,
                            ),
                            child: Slider(
                              value: severityLevel,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              onChanged: (value) {
                                setState(() {
                                  severityLevel = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1',
                                style: TextStyles.font14whitebold.copyWith(
                                  color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                                ),
                              ),
                              Text(
                                '10',
                                style: TextStyles.font14whitebold.copyWith(
                                  color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                                width: 1,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isArabic ? 'السابق' : 'Back',
                              style: TextStyles.font16white600w.copyWith(
                                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to Question 4 or submit
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Symptom analysis complete! (More questions pending)'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isArabic ? 'التالي' : 'Next',
                              style: TextStyles.font16white600w,
                            ),
                          ),
                        ),
                      ],
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

  Color _getSeverityColor(double level, bool isDark) {
    if (level <= 3) return Colors.green;
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }

  String _getSeverityLabel(double level, bool isArabic) {
    if (level <= 3) return isArabic ? 'خفيف' : 'Mild';
    if (level <= 6) return isArabic ? 'متوسط' : 'Moderate';
    return isArabic ? 'شديد' : 'Severe';
  }
}
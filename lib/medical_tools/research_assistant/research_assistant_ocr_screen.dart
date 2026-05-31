import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantOcrScreen extends StatelessWidget {
  final String extractedText;

  const ResearchAssistantOcrScreen({
    super.key,
    required this.extractedText,
  });

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
                      isArabic ? 'النص المستخرج' : 'Extracted Text',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 30),

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.text_fields,
                                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                              ),
                              SizedBox(width: 10),
                              Text(
                                isArabic ? 'OCR - استخراج النص' : 'OCR - Text Extraction',
                                style: TextStyles.font16white600w.copyWith(
                                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            extractedText.isNotEmpty
                                ? extractedText
                                : (isArabic ? 'لم يتم استخراج أي نص' : 'No text extracted'),
                            style: TextStyles.font14whitebold.copyWith(
                              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                              fontWeight: FontWeight.normal,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFF0D2137),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorManager.primaryBlue,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: ColorManager.primaryBlue),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              isArabic
                                  ? 'يمكنك نسخ النص واستخدامه في تطبيقات أخرى'
                                  : 'You can copy this text and use it in other applications',
                              style: TextStyles.font14whitebold.copyWith(
                                color: ColorManager.primaryBlue,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
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
            isArabic ? 'استخراج النص' : 'Text Extraction',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
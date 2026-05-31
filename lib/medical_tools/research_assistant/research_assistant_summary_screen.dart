import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> summary;
  final String paperTitle;

  const ResearchAssistantSummaryScreen({
    super.key,
    required this.summary,
    required this.paperTitle,
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
                      isArabic ? 'ملخص الورقة' : 'Paper Summary',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        paperTitle,
                        style: TextStyles.font16white600w.copyWith(
                          color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    if (summary['background'] != null)
                      _buildSection(
                        isArabic ? 'الخلفية' : 'Background',
                        summary['background'],
                        isDark,
                        isArabic,
                      ),

                    if (summary['methods'] != null)
                      _buildSection(
                        isArabic ? 'المنهجية' : 'Methods',
                        summary['methods'],
                        isDark,
                        isArabic,
                      ),

                    if (summary['keyFindings'] != null)
                      _buildSection(
                        isArabic ? 'النتائج الرئيسية' : 'Key Findings',
                        summary['keyFindings'],
                        isDark,
                        isArabic,
                      ),

                    if (summary['conclusions'] != null)
                      _buildSection(
                        isArabic ? 'الاستنتاجات' : 'Conclusions',
                        summary['conclusions'],
                        isDark,
                        isArabic,
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
            isArabic ? 'الملخص' : 'Summary',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark, bool isArabic) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.article,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                  size: 20,
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            content,
            style: TextStyles.font16white600w.copyWith( // ✅
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );
  }
}
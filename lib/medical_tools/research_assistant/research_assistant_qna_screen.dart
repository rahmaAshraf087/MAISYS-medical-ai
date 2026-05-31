import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantQnaScreen extends StatelessWidget {
  final List<dynamic> qaPairs;
  final String paperTitle;

  const ResearchAssistantQnaScreen({
    super.key,
    required this.qaPairs,
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
                      isArabic ? 'أسئلة وأجوبة' : 'Questions & Answers',
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

                    if (qaPairs.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: 80,
                              color: isDark ? Colors.white24 : ColorManager.lightBorder,
                            ),
                            SizedBox(height: 20),
                            Text(
                              isArabic ? 'لا توجد أسئلة متاحة' : 'No questions available',
                              style: TextStyles.font16white600w.copyWith(
                                color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...qaPairs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final qa = entry.value;

                        return _buildQACard(
                          index + 1,
                          qa['question'] ?? '',
                          qa['answer'] ?? '',
                          isDark,
                          isArabic,
                        );
                      }).toList(),
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
            isArabic ? 'أسئلة وأجوبة' : 'Q&A',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQACard(int number, String question, String answer, bool isDark, bool isArabic) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'Q$number',
                      style: TextStyles.font14whitebold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyles.font16white600w.copyWith(
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    answer,
                    style: TextStyles.font16white600w.copyWith( // ✅
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
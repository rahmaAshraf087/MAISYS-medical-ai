import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class DrugInteractionResultScreen extends StatelessWidget {
  final List<String> medications;
  final List<Map<String, dynamic>> interactions; // ✅ من الـ API
  final String summary;
  final List<String> warnings;

  const DrugInteractionResultScreen({
    super.key,
    required this.medications,
    required this.interactions,
    required this.summary,
    required this.warnings,
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
                      isArabic ? 'نتائج التفاعل' : 'Interaction Results',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 20),

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
                          Text(
                            isArabic ? 'الأدوية المفحوصة' : 'Checked Medications',
                            style: TextStyles.font16white600w.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...medications.map((med) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.medication,
                                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                                  size: 16,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  med,
                                  style: TextStyles.font14whitebold.copyWith(
                                    color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      isArabic ? 'التفاعلات المكتشفة (${interactions.length})' : 'Found Interactions (${interactions.length})',
                      style: TextStyles.font20whitebold.copyWith(
                        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: 15),

                    ...interactions.map((interaction) => _buildInteractionCard(interaction, isDark, isArabic)),

                    SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF0D2137),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: ColorManager.primaryBlue,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color:ColorManager.primaryBlue),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              isArabic
                                  ? 'استشر طبيبك أو الصيدلي قبل تناول هذه الأدوية معاً'
                                  : 'Consult your doctor or pharmacist before taking these medications together',
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
            isArabic ? 'نتائج التفاعل' : 'Interaction Results',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _translateSeverity(String severity, bool isArabic) {
    if (!isArabic) return severity.toUpperCase();
    switch (severity.toLowerCase()) {
      case 'severe': return 'خطير';
      case 'moderate': return 'متوسط';
      case 'low': return 'منخفض';
      default: return severity.toUpperCase();
    }
  }
  Widget _buildInteractionCard(Map<String, dynamic> interaction, bool isDark, bool isArabic) {
    final severity = interaction['severity'] as String;
    Color severityColor;

    switch (severity.toLowerCase()) {
      case 'severe':
        severityColor = Colors.red;
        break;
      case 'moderate':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.yellow;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: severityColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _translateSeverity(severity, isArabic),
                  style: TextStyles.font12lightgray400w.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          Text(
            '${(interaction['drugs'] as List).join(' + ')}',
            style: TextStyles.font16white600w.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),

          SizedBox(height: 10),

          Text(
            interaction['description'] as String? ?? '',
            style: TextStyles.font16white600w.copyWith( // ✅
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          SizedBox(height: 8),

          // ✅ أضيفي الـ recommendation
          if (interaction['recommendation'] != null)
            Text(
              interaction['recommendation'] as String,
              style: TextStyles.font12lightgray400w.copyWith(
                color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          if (warnings.isNotEmpty) ...[
            SizedBox(height: 20),
            Text(
              isArabic ? 'تحذيرات' : 'Warnings',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 10),
            ...warnings.map((w) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(w,
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],

// Summary
          if (summary.isNotEmpty) ...[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                borderRadius: BorderRadius.circular(15),
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
                    isArabic ? 'الملخص' : 'Summary',
                    style: TextStyles.font16white600w.copyWith(
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    summary,
                    style: TextStyles.font14whitebold.copyWith(
                      color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
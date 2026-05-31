import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class LabTestResultScreen extends StatelessWidget {
  final String extractedText;        // ✅ أضفنا
  final Map<String, dynamic> analysis; // ✅ أضفنا

  const LabTestResultScreen({
    super.key,
    required this.extractedText,     // ✅ أضفنا
    required this.analysis,           // ✅ أضفنا
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    // Parse markers
    final markers = (analysis['markers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final summary = analysis['summary'] ?? 'No summary available';
    final urgency = analysis['urgency'] ?? 'routine';

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
                      isArabic ? 'نتائج التحليل' : 'Lab Test Results',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 20),

                    _buildUrgencyBadge(urgency, isDark, isArabic),

                    SizedBox(height: 20),

                    _buildSummaryCard(summary, isDark, isArabic),

                    SizedBox(height: 20),

                    if (markers.isNotEmpty) ...[
                      Text(
                        isArabic ? 'المؤشرات' : 'Test Markers',
                        style: TextStyles.font20whitebold.copyWith(
                          color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...markers.map((marker) => _buildMarkerCard(marker, isDark, isArabic)),
                    ],

                    SizedBox(height: 20),

                    ExpansionTile(
                      title: Text(
                        isArabic ? 'النص المستخرج' : 'Extracted Text',
                        style: TextStyles.font16white600w.copyWith(
                          color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            extractedText,
                            style: TextStyles.font14whitebold.copyWith(
                              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
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
            isArabic?'نتائج التحاليل':'Lab Results',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyBadge(String urgency, bool isDark, bool isArabic) {
    Color badgeColor;
    String badgeText;

    switch (urgency.toLowerCase()) {
      case 'urgent':
        badgeColor = Colors.red;
        badgeText = isArabic ? 'عاجل' : 'URGENT';
        break;
      case 'follow-up':
        badgeColor = Colors.orange;
        badgeText = isArabic ? 'متابعة' : 'FOLLOW-UP';
        break;
      default:
        badgeColor = Colors.green;
        badgeText = isArabic ? 'روتيني' : 'ROUTINE';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeText,
        style: TextStyles.font14whitebold.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String summary, bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الملخص' : 'Summary',
            style: TextStyles.font16white600w.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            summary,
            style: TextStyles.font16white600w.copyWith( // ✅
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerCard(Map<String, dynamic> marker, bool isDark, bool isArabic) {
    final name = marker['name'] ?? 'Unknown';
    final value = marker['value']?.toString() ?? '-';
    final unit = marker['unit'] ?? '';
    final status = marker['status'] ?? 'normal';
    final interpretation = marker['interpretation'] ?? '';

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'high':
        statusColor = Colors.red;
        break;
      case 'low':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: statusColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isArabic) ...[
                Expanded(
                  child: Text(
                    name,
                    style: TextStyles.font16white600w.copyWith(
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyles.font16white600w.copyWith(
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10),
          Text(
            '$value $unit',
            style: TextStyles.font20whitebold.copyWith(
              color: statusColor,
            ),
          ),
          if (interpretation.isNotEmpty) ...[
            SizedBox(height: 10),
            Text(
              interpretation,
              style: TextStyles.font16white600w.copyWith( // ✅
                color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/theme/style_helper.dart';

class MedicalDisclaimerWidget extends StatelessWidget {
  const MedicalDisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context
        .watch<LanguageCubit>()
        .state
        .isArabic;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2D1F0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF8B6914), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB020), size: 24),
          SizedBox(width: 15),
          Expanded(
            child: RichText(
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isArabic
                        ? 'إخلاء المسؤولية الطبية: '
                        : 'Medical Disclaimer: ',
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: Color(0xFFFFB020),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: isArabic
                        ? 'تقدم MAISYS معلومات طبية لأغراض تعليمية فقط. لا تشخص أو تعالج أو تحل محل الاستشارة الطبية المتخصصة. استشر دائماً مقدم الرعاية الصحية للقرارات الطبية.'
                        : 'MAISYS provides medical information for educational purposes only. It does not diagnose, treat, or replace professional medical advice. Always consult a healthcare provider for medical decisions.',
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

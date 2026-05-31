import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String languageCode; // 'en' or 'ar'
  final bool isArabic;

  const LanguageState({
    required this.languageCode,
    required this.isArabic,
  });

  @override
  List<Object?> get props => [languageCode, isArabic];

  LanguageState copyWith({
    String? languageCode,
    bool? isArabic,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
      isArabic: isArabic ?? this.isArabic,
    );
  }
}
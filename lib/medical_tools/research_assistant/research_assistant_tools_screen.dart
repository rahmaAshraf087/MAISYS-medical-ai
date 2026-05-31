import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_ocr_screen.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_qna_screen.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_summary_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_translation_screen.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_chat_screen.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantToolsScreen extends StatefulWidget {
  final String paperId;
  final String paperTitle;

  const ResearchAssistantToolsScreen({
    super.key,
    required this.paperId,
    required this.paperTitle,
  });

  @override
  State<ResearchAssistantToolsScreen> createState() => _ResearchAssistantToolsScreenState();
}

class _ResearchAssistantToolsScreenState extends State<ResearchAssistantToolsScreen> {
  bool isSummarizing = false;
  bool isGeneratingQA = false;
  bool isTranslating = false;
  String _selectedLanguage = 'en';


  Future<void> _handleSummarize() async {
    final isArabic = context.read<LanguageCubit>().state.isArabic;
    setState(() => isSummarizing = true);

    final result = await ApiService.summarizePaperWithLanguage(
      widget.paperId,
      _selectedLanguage, // ✅
    );

    if (!mounted) return;
    setState(() => isSummarizing = false);

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantSummaryScreen(
            summary: result['summary'],
            paperTitle: widget.paperTitle,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ??
              (isArabic ? 'فشل التلخيص' : 'Summarization failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleGenerateQA() async {
    final isArabic = context.read<LanguageCubit>().state.isArabic;
    setState(() => isGeneratingQA = true);

    final result = await ApiService.generateQAWithLanguage(
      widget.paperId,
      _selectedLanguage, // ✅
    );

    if (!mounted) return;
    setState(() => isGeneratingQA = false);

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantQnaScreen(
            qaPairs: result['qaPairs'],
            paperTitle: widget.paperTitle,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ??
              (isArabic ? 'فشل توليد الأسئلة' : 'Q&A generation failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleTranslate() async {
    final isArabic = context.read<LanguageCubit>().state.isArabic;
    final targetLanguage = isArabic ? 'Arabic' : 'English';

    setState(() => isTranslating = true);

    final result = await ApiService.translatePaper(
      paperId: widget.paperId,
      targetLanguage: targetLanguage,
    );

    if (!mounted) return;
    setState(() => isTranslating = false);

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantTranslationScreen(
            originalText: result['originalText'] ?? '',
            translatedText: result['translatedText'] ?? '',
            targetLanguage: result['targetLanguage'] ?? targetLanguage,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ??
              (isArabic ? 'فشلت الترجمة' : 'Translation failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleChat() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResearchAssistantChatScreen(
          paperId: widget.paperId,
          paperTitle: widget.paperTitle,
        ),
      ),
    );
  }

  Future<void> _handleOcr() async {
    final isArabic = context.read<LanguageCubit>().state.isArabic;

    final result = await ApiService.getOcrText(widget.paperId);

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantOcrScreen(
            extractedText: result['extractedText'] ?? '',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'فشل استخراج النص' : 'Failed to get text'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                      isArabic ? 'أدوات البحث' : 'Research Tools',
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.article,
                            color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              widget.paperTitle,
                              style: TextStyles.font16white600w.copyWith(
                                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // ✅ Language Toggle
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
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
                            isArabic ? 'لغة النتائج' : 'Results Language',
                            style: TextStyles.font14whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedLanguage = 'en'),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                  onTap: () => setState(() => _selectedLanguage = 'ar'),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                    SizedBox(height: 30),
                    _buildToolCard(
                      icon: Icons.summarize,
                      title: isArabic ? 'تلخيص الورقة' : 'Summarize Paper',
                      description: isArabic
                          ? 'احصل على ملخص شامل للورقة البحثية'
                          : 'Get a comprehensive summary of the research paper',
                      onTap: _handleSummarize,
                      isLoading: isSummarizing,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),

                    _buildToolCard(
                      icon: Icons.question_answer,
                      title: isArabic ? 'أسئلة وأجوبة' : 'Q&A Generation',
                      description: isArabic
                          ? 'توليد أسئلة وأجوبة من الورقة'
                          : 'Generate questions and answers from the paper',
                      onTap: _handleGenerateQA,
                      isLoading: isGeneratingQA,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),

                    _buildToolCard(
                      icon: Icons.translate,
                      title: isArabic ? 'ترجمة' : 'Translation',
                      description: isArabic
                          ? 'ترجمة الورقة إلى العربية أو الإنجليزية'
                          : 'Translate the paper to Arabic or English',
                      onTap: _handleTranslate, // ✅ ربط حقيقي
                      isLoading: isTranslating,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),

                    _buildToolCard(
                      icon: Icons.chat,
                      title: isArabic ? 'محادثة حول الورقة' : 'Chat About Paper',
                      description: isArabic
                          ? 'اسأل أي سؤال حول الورقة'
                          : 'Ask any question about the paper',
                      onTap: _handleChat, // ✅ ربط حقيقي
                      isLoading: false,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),

                    _buildToolCard(
                      icon: Icons.text_fields,
                      title: isArabic ? 'استخراج النص (OCR)' : 'Text Extraction (OCR)',
                      description: isArabic
                          ? 'عرض النص المستخرج من الورقة البحثية'
                          : 'View extracted text from the research paper',
                      onTap: _handleOcr,
                      isLoading: false,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),

                    // ===== Papers History =====
                    FutureBuilder<Map<String, dynamic>>(
                      future: ApiService.getResearchPapers(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return SizedBox.shrink();
                        final papers = List<dynamic>.from(
                            snapshot.data?['chats'] ?? []);
                        if (papers.isEmpty) return SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: isArabic
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'الأوراق السابقة' : 'Previous Papers',
                              style: TextStyles.font20whitebold.copyWith(
                                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                              ),
                            ),
                            SizedBox(height: 15),
                            ...papers.take(5).map((paper) => GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResearchAssistantToolsScreen(
                                      paperId: paper['_id'],
                                      paperTitle: paper['paperTitle'] ?? 'Research Paper',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Color(0xFF0D1620)
                                      : ColorManager.lightBorder,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark
                                        ? Color(0xFF2D3E50)
                                        : ColorManager.lightBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (!isArabic) ...[
                                      Icon(Icons.article,
                                          color: isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue,
                                          size: 20),
                                      SizedBox(width: 12),
                                    ],
                                    Expanded(
                                      child: Text(
                                        paper['paperTitle'] ?? 'Research Paper',
                                        style: TextStyles.font14whitebold.copyWith(
                                          color: isDark
                                              ? Colors.white70
                                              : ColorManager.lightTextSecondary,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: isArabic
                                            ? TextAlign.right
                                            : TextAlign.left,
                                      ),
                                    ),
                                    if (isArabic) ...[
                                      SizedBox(width: 12),
                                      Icon(Icons.article,
                                          color: isDark
                                              ? ColorManager.primaryBlue
                                              : ColorManager.lightPrimaryBlue,
                                          size: 20),
                                    ],
                                  ],
                                ),
                              ),
                            )),
                          ],
                        );
                      },
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
            isArabic ? 'أدوات البحث' : 'Research Tools',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isDark,
    required bool isArabic,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                size: 30,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.font16white600w.copyWith(
                      color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyles.font14whitebold.copyWith(
                      color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
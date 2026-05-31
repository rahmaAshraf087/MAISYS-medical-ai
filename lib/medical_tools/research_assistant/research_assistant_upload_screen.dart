import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/medical_tools/research_assistant/research_assistant_tools_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantUploadScreen extends StatefulWidget {
  const ResearchAssistantUploadScreen({super.key});

  @override
  State<ResearchAssistantUploadScreen> createState() =>
      _ResearchAssistantUploadScreenState();
}

class _ResearchAssistantUploadScreenState
    extends State<ResearchAssistantUploadScreen> {
  // Optional metadata
  final titleController = TextEditingController();
  final authorsController = TextEditingController();
  final journalController = TextEditingController();

  File? selectedFile;
  String? selectedFileName;
  String? selectedFileType;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    titleController.dispose();
    authorsController.dispose();
    journalController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        selectedFileName = result.files.single.name;
        selectedFileType = result.files.single.extension == 'pdf'
            ? 'application/pdf'
            : 'image/jpeg';
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
        selectedFileName = image.name;
        selectedFileType = 'image/jpeg';
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
        selectedFileName = image.name;
        selectedFileType = 'image/jpeg';
      });
    }
  }

  Future<void> _handleUpload() async {
    final isArabic = context.read<LanguageCubit>().state.isArabic;

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic
              ? 'الرجاء اختيار ملف أولاً'
              : 'Please select a file first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isUploading = true);

    // ✅ الـ title اختياري — لو مكتبش نستخدم اسم الملف
    final paperTitle = titleController.text.trim().isNotEmpty
        ? titleController.text.trim()
        : selectedFileName ?? 'Research Paper';

    final authors = authorsController.text.trim().isNotEmpty
        ? authorsController.text
        .split(',')
        .map((a) => a.trim())
        .toList()
        : <String>[];

    // خطوة 1: إنشاء الـ research chat
    final createResult = await ApiService.uploadResearchPaper(
      paperTitle: paperTitle,
      authors: authors,
      journal: journalController.text.trim().isNotEmpty
          ? journalController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (createResult['success'] != true) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(createResult['message'] ?? 'Failed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final paperId = createResult['chat']['_id'];

    // خطوة 2: رفع الملف واستخراج النص
    final bytes = await selectedFile!.readAsBytes();
    final fileBase64 = base64Encode(bytes);

    final uploadResult = await ApiService.uploadResearchFile(
      paperId: paperId,
      fileBase64: fileBase64,
      fileType: selectedFileType ?? 'image/jpeg',
      fileName: selectedFileName ?? 'paper',
    );

    if (!mounted) return;
    setState(() => isUploading = false);

    if (uploadResult['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantToolsScreen(
            paperId: paperId,
            paperTitle: paperTitle,
          ),
        ),
      );
    } else {
      // ✅ حتى لو فشل الـ file upload، نروح للـ tools screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResearchAssistantToolsScreen(
            paperId: paperId,
            paperTitle: paperTitle,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor:
      isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark, isArabic),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'مساعد البحث' : 'Research Assistant',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark
                            ? ColorManager.primaryBlue
                            : ColorManager.lightPrimaryBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      isArabic
                          ? 'ارفع ورقتك البحثية (PDF أو صورة)'
                          : 'Upload your research paper (PDF or image)',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark
                            ? Colors.white70
                            : ColorManager.lightTextSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 25),

                    // ===== File Upload Section =====
                    _buildFileUploadSection(isDark, isArabic),

                    SizedBox(height: 25),

                    // ===== Optional Metadata =====
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Color(0xFF1E2A3A)
                            : ColorManager.lightContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Color(0xFF2D3E50)
                              : ColorManager.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 16,
                                  color: isDark
                                      ? ColorManager.primaryBlue
                                      : ColorManager.lightPrimaryBlue),
                              SizedBox(width: 8),
                              Text(
                                isArabic
                                    ? 'معلومات اختيارية'
                                    : 'Optional Information',
                                style: TextStyles.font14whitebold.copyWith(
                                  color: isDark
                                      ? ColorManager.primaryBlue
                                      : ColorManager.lightPrimaryBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          _buildOptionalField(
                            label: isArabic ? 'عنوان الورقة' : 'Paper Title',
                            hint: isArabic
                                ? 'اتركه فارغاً لاستخدام اسم الملف'
                                : 'Leave empty to use filename',
                            controller: titleController,
                            isDark: isDark,
                            isArabic: isArabic,
                          ),
                          SizedBox(height: 12),
                          _buildOptionalField(
                            label: isArabic ? 'المؤلفون' : 'Authors',
                            hint: isArabic
                                ? 'مثال: أحمد، سارة'
                                : 'e.g. John, Sarah',
                            controller: authorsController,
                            isDark: isDark,
                            isArabic: isArabic,
                          ),
                          SizedBox(height: 12),
                          _buildOptionalField(
                            label: isArabic ? 'المجلة' : 'Journal',
                            hint: isArabic
                                ? 'اسم المجلة'
                                : 'Journal name',
                            controller: journalController,
                            isDark: isDark,
                            isArabic: isArabic,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25),

                    // Upload Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                        isUploading || selectedFile == null
                            ? null
                            : _handleUpload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? ColorManager.primaryBlue
                              : ColorManager.lightPrimaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: isUploading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              isArabic
                                  ? 'جاري الرفع والتحليل...'
                                  : 'Uploading & Processing...',
                              style: TextStyles.font16white600w,
                            ),
                          ],
                        )
                            : Text(
                          isArabic
                              ? 'رفع وتحليل الورقة'
                              : 'Upload & Analyze Paper',
                          style: TextStyles.font16white600w,
                        ),
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

  Widget _buildFileUploadSection(bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: selectedFile != null
              ? Colors.green
              : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
          width: selectedFile != null ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            selectedFile != null ? Icons.check_circle : Icons.upload_file,
            size: 50,
            color: selectedFile != null
                ? Colors.green
                : (isDark
                ? ColorManager.primaryBlue
                : ColorManager.lightPrimaryBlue),
          ),
          SizedBox(height: 12),
          Text(
            selectedFile != null
                ? selectedFileName ?? 'File selected'
                : (isArabic
                ? 'لم يتم اختيار ملف بعد'
                : 'No file selected yet'),
            style: TextStyles.font16white600w.copyWith(
              color: selectedFile != null
                  ? Colors.green
                  : (isDark
                  ? Colors.white
                  : ColorManager.lightTextPrimary),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildUploadButton(
                  icon: Icons.picture_as_pdf,
                  label: isArabic ? 'PDF' : 'PDF',
                  isDark: isDark,
                  onTap: _pickFile,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildUploadButton(
                  icon: Icons.photo_library,
                  label: isArabic ? 'صورة' : 'Image',
                  isDark: isDark,
                  onTap: _pickImage,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildUploadButton(
                  icon: Icons.camera_alt,
                  label: isArabic ? 'كاميرا' : 'Camera',
                  isDark: isDark,
                  onTap: _takePhoto,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? ColorManager.primaryBlue.withOpacity(0.15)
              : ColorManager.lightPrimaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? ColorManager.primaryBlue
                : ColorManager.lightPrimaryBlue,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
                size: 22),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyles.font12lightgray400w.copyWith(
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    required bool isArabic,
  }) {
    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyles.font12lightgray400w.copyWith(
              color: isDark ? Colors.white60 : ColorManager.lightTextSecondary,
            )),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : ColorManager.lightTextSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: isDark
                ? Color(0xFF0D1620)
                : ColorManager.lightBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : ColorManager.lightTextPrimary),
          ),
          SizedBox(width: 15),
          Text(
            isArabic ? 'مساعد البحث' : 'Research Assistant',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/lab_test/lab_test_result_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class LabTestUploadScreen extends StatefulWidget {
  const LabTestUploadScreen({super.key});

  @override
  State<LabTestUploadScreen> createState() => _LabTestUploadScreenState();
}

class _LabTestUploadScreenState extends State<LabTestUploadScreen> {
  File? selectedFile;
  File? capturedImage;
  bool isUploading = false;
  String _selectedLanguage = 'en';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          capturedImage = null;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (image != null) {
        setState(() {
          capturedImage = File(image.path);
          selectedFile = null;
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (selectedFile == null && capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or capture an image first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      String? imageBase64;

      if (capturedImage != null) {
        final bytes = await capturedImage!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      } else if (selectedFile != null) {
        final bytes = await selectedFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final result = await ApiService.analyzeLabReport(
        imageBase64: imageBase64,
          language: _selectedLanguage,
      );

      if (!mounted) return ;

      setState(() {
        isUploading = false;
      });

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LabTestResultScreen(
              extractedText: result['extractedText'],
              analysis: result['analysis'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Analysis failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
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
            _buildTopHeader(context, isDark, isArabic), // ✅ مررنا isDark و isArabic

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'شرح نتائج التحاليل' : 'Lab Test Explainer',
                      style: TextStyles.font28primarybluebold.copyWith(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      isArabic
                          ? 'قم برفع صورة من نتائج التحاليل للحصول على تحليل شامل'
                          : 'Upload a photo of your lab results for comprehensive analysis',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    SizedBox(height: 30),

                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            selectedFile != null || capturedImage != null
                                ? Icons.check_circle
                                : Icons.upload_file,
                            size: 60,
                            color: selectedFile != null || capturedImage != null
                                ? Colors.green
                                : (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                          ),
                          SizedBox(height: 20),
                          Text(
                            selectedFile != null
                                ? selectedFile!.path.split('/').last
                                : (capturedImage != null
                                ? (isArabic ? 'تم التقاط الصورة' : 'Image captured')
                                : (isArabic ? 'اختر ملف أو التقط صورة' : 'Choose file or take photo')),
                            style: TextStyles.font16white600w.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickFile,
                                  icon: Icon(Icons.folder_open, color: Colors.white),
                                  label: Text(
                                    isArabic ? 'اختر ملف' : 'Choose File',
                                    style: TextStyles.font14whitebold,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _captureImage,
                                  icon: Icon(Icons.camera_alt, color: Colors.white),
                                  label: Text(
                                    isArabic ? 'التقط صورة' : 'Take Photo',
                                    style: TextStyles.font14whitebold,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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

                    // ✅ Language Toggle
                    Container(
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
                            isArabic ? 'لغة الرد' : 'Response Language',
                            style: TextStyles.font16white600w.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedLanguage = 'en'),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
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
                                  onTap: () =>
                                      setState(() => _selectedLanguage = 'ar'),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
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
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isUploading ? null : _handleUpload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                        ),
                        child: isUploading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          isArabic ? 'تحليل' : 'Analyze',
                          style: TextStyles.font16white600w,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

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
                          Icon(Icons.info_outline, color: ColorManager.primaryBlue),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              isArabic
                                  ? 'تأكد من وضوح الصورة وظهور جميع القيم'
                                  : 'Make sure the image is clear and all values are visible',
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

  // ✅ التعديل الوحيد: أضفنا isDark و isArabic كـ parameters
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
            isArabic ? 'شرح التحاليل' : 'Lab Test Explainer',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
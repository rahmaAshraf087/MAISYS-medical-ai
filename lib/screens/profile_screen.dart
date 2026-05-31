import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  bool isSaving = false;
  String _countryCode = '+20'; // مصر default
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();

  // Dropdown values
  String? selectedGender;
  String? selectedBloodType;

  // Medical
  List<String> medications = [];
  List<String> allergies = [];
  List<String> conditions = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    medicationController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  void _removePhoto() {
    setState(() => _profileImage = null);
  }

  void _showImageOptions(BuildContext context, bool isDark, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
              title: Text(
                isArabic ? 'اختر من المعرض' : 'Choose from Gallery',
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
              title: Text(
                isArabic ? 'التقاط صورة' : 'Take Photo',
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  isArabic ? 'حذف الصورة' : 'Remove Photo',
                  style: TextStyles.font16white600w.copyWith(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto();
                },
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _loadProfile() async {
    final result = await ApiService.getUserProfile();
    if (!mounted) return;

    // ✅ تحميل الصورة المحفوظة
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('profile_image_path');
    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      setState(() => _profileImage = File(savedImagePath));
    }

    if (result['success'] == true) {
      final user = result['user'];
      setState(() {
        isLoading = false;
        final firstName = user['firstName'] ?? '';
        firstNameController.text = firstName.contains('@') ? '' : firstName;
        lastNameController.text = user['lastName'] ?? '';
        emailController.text = user['email'] ?? '';
        phoneController.text = user['phone'] ?? '';
        ageController.text = user['age']?.toString() ?? '';
        selectedGender = user['gender'];
        selectedBloodType = user['bloodType'];
        final medical = user['medical'];
        if (medical != null) {
          medications = List<String>.from(medical['medications'] ?? []);
          allergies = List<String>.from(medical['allergies'] ?? []);
          conditions = List<String>.from(medical['conditions'] ?? []);
        }
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);

    // ✅ رفع الصورة للـ backend لو اتغيرت
    if (_profileImage != null) {
      final bytes = await _profileImage!.readAsBytes();
      final base64Str = base64Encode(bytes);
      await ApiService.uploadProfilePicture(
        imageBase64: base64Str,
        mimeType: 'image/jpeg',
      );
      // ✅ حفظ محلي كمان
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', _profileImage!.path);
    }

    final result = await ApiService.updateProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: _countryCode + phoneController.text.trim(),
      age: int.tryParse(ageController.text.trim()),
      gender: selectedGender,
      bloodType: selectedBloodType,
      medical: {
        'medications': medications,
        'allergies': allergies,
        'conditions': conditions,
      },
    );

    if (!mounted) return;
    setState(() => isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] == true
            ? (context.read<LanguageCubit>().state.isArabic
            ? 'تم حفظ البيانات بنجاح'
            : 'Profile saved successfully')
            : result['message'] ?? 'Save failed'),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
  }
  Future<void> _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
    );
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
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: isDark
                      ? ColorManager.primaryBlue
                      : ColorManager.lightPrimaryBlue,
                ),
              )
                  : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        isArabic ? 'المعلومات الشخصية' : 'Personal Information',
                        isDark),
                    SizedBox(height: 15),
                    // ===== Profile Picture =====
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: isDark
                                    ? Color(0xFF2D3E50)
                                    : ColorManager.lightBorder,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? Icon(
                                  Icons.person,
                                  size: 55,
                                  color: isDark
                                      ? ColorManager.primaryBlue
                                      : ColorManager.lightPrimaryBlue,
                                )
                                    : null,
                              ),
                              // Edit button
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _showImageOptions(context, isDark, isArabic),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? ColorManager.primaryBlue
                                          : ColorManager.lightPrimaryBlue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? ColorManager.kohly
                                            : ColorManager.lightBackground,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(Icons.edit, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () => _showImageOptions(context, isDark, isArabic),
                            child: Text(
                              isArabic ? 'تعديل الصورة' : 'Edit Photo',
                              style: TextStyles.font14whitebold.copyWith(
                                color: isDark
                                    ? ColorManager.primaryBlue
                                    : ColorManager.lightPrimaryBlue,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      label: isArabic ? 'الاسم الأول' : 'First Name',
                      controller: firstNameController,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      label: isArabic ? 'اسم العائلة' : 'Last Name',
                      controller: lastNameController,
                      isDark: isDark,
                      isArabic: isArabic,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      label: isArabic ? 'البريد الإلكتروني' : 'Email',
                      controller: emailController,
                      isDark: isDark,
                      isArabic: isArabic,
                      enabled: false,
                    ),
                    SizedBox(height: 12),
                    // Phone with country code
                    Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'رقم الهاتف' : 'Phone',
                          style: TextStyles.font14whitebold.copyWith(
                            color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            // Country Code Picker
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                                ),
                              ),
                              child: CountryCodePicker(
                                onChanged: (code) {
                                  setState(() => _countryCode = code.dialCode ?? '+20');
                                },
                                initialSelection: 'EG',
                                favorite: ['EG', 'SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'JO', 'LB', 'SY'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                textStyle: TextStyle(
                                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                                  fontSize: 14,
                                ),
                                dialogBackgroundColor: isDark
                                    ? ColorManager.loginContainer
                                    : ColorManager.lightContainer,
                                searchStyle: TextStyle(
                                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Phone number field
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: isArabic ? 'رقم الهاتف' : 'Phone number',
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : ColorManager.lightTextSecondary,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Color(0xFF1E2A3A)
                                      : ColorManager.lightBorder,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? Color(0xFF2D3E50)
                                          : ColorManager.lightBorder,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? Color(0xFF2D3E50)
                                          : ColorManager.lightBorder,
                                    ),
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      label: isArabic ? 'العمر' : 'Age',
                      controller: ageController,
                      isDark: isDark,
                      isArabic: isArabic,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    _buildDropdown(
                      label: isArabic ? 'الجنس' : 'Gender',
                      value: selectedGender,
                      items: [
                        DropdownMenuItem(
                            value: 'male',
                            child: Text(isArabic ? 'ذكر' : 'Male')),
                        DropdownMenuItem(
                            value: 'female',
                            child: Text(isArabic ? 'أنثى' : 'Female')),
                        DropdownMenuItem(
                            value: 'other',
                            child: Text(isArabic ? 'آخر' : 'Other')),
                      ],
                      onChanged: (val) =>
                          setState(() => selectedGender = val),
                      isDark: isDark,
                      isArabic: isArabic,
                    ),
                    SizedBox(height: 12),
                    _buildDropdown(
                      label: isArabic ? 'فصيلة الدم' : 'Blood Type',
                      value: selectedBloodType,
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                          .map((t) => DropdownMenuItem(
                          value: t, child: Text(t)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedBloodType = val),
                      isDark: isDark,
                      isArabic: isArabic,
                    ),
                    SizedBox(height: 25),
                    _buildSectionTitle(
                        isArabic ? 'المعلومات الطبية' : 'Medical Information',
                        isDark),
                    SizedBox(height: 15),
                    _buildTagsSection(
                      label: isArabic ? 'الأدوية' : 'Medications',
                      tags: medications,
                      isDark: isDark,
                      isArabic: isArabic,
                      onAdd: (val) =>
                          setState(() => medications.add(val)),
                      onRemove: (i) =>
                          setState(() => medications.removeAt(i)),
                    ),
                    SizedBox(height: 15),
                    _buildTagsSection(
                      label: isArabic ? 'الحساسية' : 'Allergies',
                      tags: allergies,
                      isDark: isDark,
                      isArabic: isArabic,
                      onAdd: (val) =>
                          setState(() => allergies.add(val)),
                      onRemove: (i) =>
                          setState(() => allergies.removeAt(i)),
                    ),
                    SizedBox(height: 15),
                    _buildTagsSection(
                      label: isArabic ? 'الحالات المرضية' : 'Medical Conditions',
                      tags: conditions,
                      isDark: isDark,
                      isArabic: isArabic,
                      onAdd: (val) =>
                          setState(() => conditions.add(val)),
                      onRemove: (i) =>
                          setState(() => conditions.removeAt(i)),
                    ),
                    SizedBox(height: 30),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? ColorManager.primaryBlue
                              : ColorManager.lightPrimaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isSaving
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                            isArabic ? 'حفظ البيانات' : 'Save Profile',
                            style: TextStyles.font16white600w),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isArabic ? 'تسجيل الخروج' : 'Logout',
                          style: TextStyles.font16white600w,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
            isArabic ? 'الملف الشخصي' : 'Profile',
            style: TextStyles.font20whitebold.copyWith(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyles.font20whitebold.copyWith(
        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isDark,
    required bool isArabic,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
            )),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required bool isDark,
    required bool isArabic,
  }) {
    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
            )),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                isArabic ? 'اختر' : 'Select',
                style: TextStyle(
                  color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                ),
              ),
              isExpanded: true,
              dropdownColor:
              isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
              style: TextStyle(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection({
    required String label,
    required List<String> tags,
    required bool isDark,
    required bool isArabic,
    required Function(String) onAdd,
    required Function(int) onRemove,
  }) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment:
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyles.font14whitebold.copyWith(
              color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
            )),
        SizedBox(height: 8),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.asMap().entries.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.primaryBlue.withOpacity(0.2)
                      : ColorManager.lightPrimaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(e.value,
                        style: TextStyles.font12lightgray400w.copyWith(
                          color: isDark
                              ? ColorManager.primaryBlue
                              : ColorManager.lightPrimaryBlue,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onRemove(e.key),
                      child: Icon(Icons.close,
                          size: 14,
                          color: isDark
                              ? ColorManager.primaryBlue
                              : ColorManager.lightPrimaryBlue),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        SizedBox(height: 8),
        Row(
          children: [
            if (isArabic)
              GestureDetector(
                onTap: () {
                  if (controller.text.trim().isNotEmpty) {
                    onAdd(controller.text.trim());
                    controller.clear();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            if (isArabic) SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: isArabic ? 'أضف...' : 'Add...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white38
                        : ColorManager.lightTextSecondary,
                  ),
                  filled: true,
                  fillColor:
                  isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark
                          ? Color(0xFF2D3E50)
                          : ColorManager.lightBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark
                          ? Color(0xFF2D3E50)
                          : ColorManager.lightBorder,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    onAdd(val.trim());
                    controller.clear();
                  }
                },
              ),
            ),
            if (!isArabic) SizedBox(width: 10),
            if (!isArabic)
              GestureDetector(
                onTap: () {
                  if (controller.text.trim().isNotEmpty) {
                    onAdd(controller.text.trim());
                    controller.clear();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
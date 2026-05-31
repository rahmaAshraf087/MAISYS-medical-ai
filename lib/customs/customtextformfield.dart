

import 'package:flutter/material.dart';
import 'package:maisys/theme/color_manager.dart';



 //String? pass1;

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller; // ✅ Add this
  final TextInputType keyboard;
  final String hinttext;
  final String cases;
  final bool? isobsecure;
  final Widget? prefixicon;
  final Widget? sufixicon;
  final bool isDark;

  const CustomTextFormField({
    super.key,
    this.controller, // ✅ Add this
    required this.keyboard,
    required this.hinttext,
    required this.cases,
    this.isobsecure,
    this.prefixicon,
    this.sufixicon,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // ✅ Add this
      keyboardType: keyboard,
      obscureText: isobsecure ?? false,
      style: TextStyle(
        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey : ColorManager.lightTextSecondary,
        ),
        prefixIcon: prefixicon,
        suffixIcon: sufixicon,
        filled: true,
        fillColor: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? BorderSide.none
              : BorderSide(color: ColorManager.lightBorder),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (cases == 'email') {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Invalid email format';
          }
        }
        if (cases == 'password' || cases == 'signUppassword') {
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
        }
        // ✅ confirmPassword — بس نتأكد إنه مش فاضي، المقارنة بتتم في sign_up.dart
        if (cases == 'confirmPassword') {
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
        }
        if (cases == 'fullName') {
          if (value.trim().length < 2) {
            return 'Name must be at least 2 characters';
          }
        }
        return null;
      },
    );
  }
}
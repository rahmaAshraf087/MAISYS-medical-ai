import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isLoading = false;
  bool obscure1 = true;
  bool obscure2 = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.resetPassword(
      resetToken: widget.resetToken,
      newPassword: passwordController.text,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Login()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Reset failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Reset Password',
                style: TextStyles.font28primarybluebold.copyWith(
                  color: isDark
                      ? ColorManager.primaryBlue
                      : ColorManager.lightPrimaryBlue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your new password',
                style: TextStyles.font16gray600w.copyWith(
                  color: isDark
                      ? Colors.white70
                      : ColorManager.lightTextSecondary,
                ),
              ),
              SizedBox(height: 40),
              Text('New Password',
                  style: TextStyles.font14whitebold.copyWith(
                    color: isDark
                        ? Colors.white
                        : ColorManager.lightTextPrimary,
                  )),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscure1,
                style: TextStyle(
                  color:
                  isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white54
                        : ColorManager.lightTextSecondary,
                  ),
                  filled: true,
                  fillColor:
                  isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                  Icon(Icons.lock, color: ColorManager.gray),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => obscure1 = !obscure1),
                    child: Icon(
                      obscure1 ? Icons.visibility_off : Icons.visibility,
                      color: ColorManager.gray,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Confirm Password',
                  style: TextStyles.font14whitebold.copyWith(
                    color: isDark
                        ? Colors.white
                        : ColorManager.lightTextPrimary,
                  )),
              SizedBox(height: 8),
              TextField(
                controller: confirmController,
                obscureText: obscure2,
                style: TextStyle(
                  color:
                  isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white54
                        : ColorManager.lightTextSecondary,
                  ),
                  filled: true,
                  fillColor:
                  isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                  Icon(Icons.lock, color: ColorManager.gray),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => obscure2 = !obscure2),
                    child: Icon(
                      obscure2 ? Icons.visibility_off : Icons.visibility,
                      color: ColorManager.gray,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : Text('Reset Password',
                      style: TextStyles.font16white600w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
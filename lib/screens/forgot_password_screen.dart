import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/screens/reset_password_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  bool isLoading = false;
  bool otpSent = false;
  String? enteredEmail;

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (emailController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final result = await ApiService.forgotPassword(
      email: emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result['success'] == true) {
      setState(() {
        otpSent = true;
        enteredEmail = emailController.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to send OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _verifyOTP() async {
    if (otpController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final result = await ApiService.verifyOTP(
      email: enteredEmail!,
      otp: otpController.text.trim(),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            resetToken: result['resetToken'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Invalid OTP'),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back,
                    color: isDark
                        ? Colors.white
                        : ColorManager.lightTextPrimary),
              ),
              SizedBox(height: 40),
              Text(
                'Forgot Password',
                style: TextStyles.font28primarybluebold.copyWith(
                  color: isDark
                      ? ColorManager.primaryBlue
                      : ColorManager.lightPrimaryBlue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                otpSent
                    ? 'Enter the 6-digit OTP sent to $enteredEmail'
                    : 'Enter your email to receive an OTP',
                style: TextStyles.font16gray600w.copyWith(
                  color: isDark
                      ? Colors.white70
                      : ColorManager.lightTextSecondary,
                ),
              ),
              SizedBox(height: 40),

              if (!otpSent) ...[
                Text('Email',
                    style: TextStyles.font14whitebold.copyWith(
                      color: isDark
                          ? Colors.white
                          : ColorManager.lightTextPrimary,
                    )),
                SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white54
                          : ColorManager.lightTextSecondary,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Color(0xFF1E2A3A)
                        : ColorManager.lightBorder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email,
                        color: ColorManager.gray),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendOTP,
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
                        : Text('Send OTP',
                        style: TextStyles.font16white600w),
                  ),
                ),
              ] else ...[
                Text('OTP Code',
                    style: TextStyles.font14whitebold.copyWith(
                      color: isDark
                          ? Colors.white
                          : ColorManager.lightTextPrimary,
                    )),
                SizedBox(height: 8),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                  ),
                  decoration: InputDecoration(
                    hintText: '------',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white54
                          : ColorManager.lightTextSecondary,
                      letterSpacing: 10,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: isDark
                        ? Color(0xFF1E2A3A)
                        : ColorManager.lightBorder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyOTP,
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
                        : Text('Verify OTP',
                        style: TextStyles.font16white600w),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => otpSent = false),
                    child: Text(
                      'Resend OTP',
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark
                            ? ColorManager.primaryBlue
                            : ColorManager.lightPrimaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:maisys/customs/customtextformfield.dart';
import 'package:maisys/overviews/overviewscreen.dart';
import 'package:maisys/screens/forgot_password_screen.dart';
import 'package:maisys/screens/sign_up.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isobsecured = true;
  bool isLoading = false;
  final GlobalKey<FormState> loginformstate = GlobalKey();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!loginformstate.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return ;
    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      // Success - Navigate to Overview
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OverviewScreen()),
      );
    } else {
      // Error - Show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.kohly : ColorManager.lightBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Form(
            key: loginformstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        isDark
                            ? "assets/svgs/appbar_logo/WhiteLogo.png"
                            : "assets/svgs/appbar_logo/BlackLogo.png",
                        width: 120,
                        height: 40,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? ColorManager.loginContainer : ColorManager.lightContainer,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyles.font28primarybluebold.copyWith(
                            color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Sign in to continue to MAISYS',
                          style: TextStyles.font16gray600w.copyWith(
                            color: isDark ? Colors.grey : ColorManager.lightTextSecondary, // ✅ تعديل
                          ),
                        ),
                        SizedBox(height: 25),

                        // Email Field
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅ تعديل
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: CustomTextFormField(
                            controller: emailController,
                            keyboard: TextInputType.emailAddress,
                            hinttext: "Enter your email",
                            cases: 'email',
                            prefixicon: Icon(Icons.email, color: ColorManager.gray),
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(height: 15),

                        // Password Field
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "Password",
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅ تعديل
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        CustomTextFormField(
                          controller: passwordController,
                          keyboard: TextInputType.text,
                          hinttext: "Enter your password",
                          cases: 'password',
                          isobsecure: isobsecured,
                          prefixicon: Icon(Icons.lock, color: ColorManager.gray),
                          sufixicon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isobsecured = !isobsecured;
                              });
                            },
                            child: Icon(
                              isobsecured ? Icons.visibility_off : Icons.visibility,
                              color: ColorManager.gray,
                            ),
                          ),
                          isDark: isDark,
                        ),
                        SizedBox(height: 8),

                        // Forget Password
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForgotPasswordScreen()),
                              );
                            },
                            child: Text(
                              "Forget password?",
                              style: TextStyles.font20primarybluebold.copyWith(
                                color: isDark
                                    ? ColorManager.primaryBlue
                                    : ColorManager.lightPrimaryBlue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        // Login Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            "Login",
                            style: TextStyles.font16white600w.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅ تعديل
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              textAlign: TextAlign.center,
                              style: TextStyles.font14whitebold,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SignUp()),
                                );
                              },
                              child: Text(
                                "Create one",
                                textAlign: TextAlign.center,
                                style: TextStyles.font20primarybluebold.copyWith(
                                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue, // ✅ تعديل
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),

                  // Privacy Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Privacy Policy', style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary,
                      ),),
                      Text(' . ', style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary,
                      ),),
                      Text("Terms of Service", style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary, // ✅ تعديل
                      ),),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/customs/customtextformfield.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isobsecured1 = true;
  bool isobsecured2 = true;
  bool isLoading = false;

  GlobalKey<FormState> signupformstate = GlobalKey();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!signupformstate.currentState!.validate()) return;

    // ✅ Confirm password check
    if (confirmPasswordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.signup(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Signup failed'),
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
          padding: EdgeInsets.all(8),
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
                Form(
                  key: signupformstate,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? ColorManager.loginContainer : ColorManager.lightContainer,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyles.font28primarybluebold.copyWith(
                            color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Join MAISYS for trusted health guidance',
                          style: TextStyles.font16gray600w.copyWith(
                            color: isDark ? Colors.grey : ColorManager.lightTextSecondary,
                          ),
                        ),
                        SizedBox(height: 25),

                        // Full Name
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Full Name',
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        CustomTextFormField(
                          controller: fullNameController,
                          keyboard: TextInputType.text,
                          hinttext: "Enter your full name",
                          cases: 'fullName',
                          prefixicon: Icon(Icons.person, color: ColorManager.gray),
                          isDark: isDark, // ✅
                        ),
                        SizedBox(height: 8),

                        // Email
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        CustomTextFormField(
                          controller: emailController,
                          keyboard: TextInputType.emailAddress,
                          hinttext: "Enter your email",
                          cases: 'email',
                          prefixicon: Icon(Icons.email, color: ColorManager.gray),
                          isDark: isDark, // ✅
                        ),
                        SizedBox(height: 8),

                        // Password
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Password',
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        CustomTextFormField(
                          controller: passwordController,
                          keyboard: TextInputType.text,
                          hinttext: "Enter your password",
                          cases: 'signUppassword',
                          isobsecure: isobsecured1,
                          prefixicon: Icon(Icons.lock, color: ColorManager.gray),
                          sufixicon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isobsecured1 = !isobsecured1;
                              });
                            },
                            child: Icon(
                              isobsecured1 ? Icons.visibility_off : Icons.visibility,
                              color: ColorManager.gray,
                            ),
                          ),
                          isDark: isDark, // ✅
                        ),
                        SizedBox(height: 8),

                        // Confirm Password
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Confirm Password',
                            textAlign: TextAlign.start,
                            style: TextStyles.font20whitebold.copyWith(
                              color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          keyboard: TextInputType.text,
                          hinttext: "Enter your password",
                          cases: 'confirmPassword',
                          isobsecure: isobsecured2,
                          prefixicon: Icon(Icons.lock, color: ColorManager.gray),
                          sufixicon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isobsecured2 = !isobsecured2;
                              });
                            },
                            child: Icon(
                              isobsecured2 ? Icons.visibility_off : Icons.visibility,
                              color: ColorManager.gray,
                            ),
                          ),
                          isDark: isDark, // ✅
                        ),
                        SizedBox(height: 15),

                        // Create Account Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue, // ✅
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          ),
                          onPressed: isLoading ? null : _handleSignup,
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
                            "Create Account",
                            style: TextStyles.font16white600w,
                          ),
                        ),
                        SizedBox(height: 15),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              textAlign: TextAlign.center,
                              style: TextStyles.font14whitebold.copyWith(
                                color: isDark ? Colors.white : ColorManager.lightTextPrimary, // ✅
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => Login()),
                                );
                              },
                              child: Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyles.font20primarybluebold.copyWith(
                                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue, // ✅
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // Privacy Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary, // ✅
                      ),
                    ),
                    Text(
                      ' . ',
                      style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary, // ✅
                      ),
                    ),
                    Text(
                      "Terms of Service",
                      style: TextStyles.font12lightgray400w.copyWith(
                        color: isDark ? Colors.grey : ColorManager.lightTextSecondary, // ✅
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
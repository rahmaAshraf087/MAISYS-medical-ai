

import 'package:flutter/material.dart';
import 'package:maisys/overviews/overviewscreen.dart';
import 'package:maisys/screens/welcome.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait 2 seconds for splash animation
    await Future.delayed(Duration(seconds: 2));

    // Check if user is logged in
    final isLoggedIn = await ApiService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in - Go to Overview
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OverviewScreen()),
      );
    } else {
      // User is NOT logged in - Go to Welcome/Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Welcome()), // Your first welcome screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/svgs/main_logo/Main_Logo.png',
              width:  MediaQuery.of(context).size.width * 0.75,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 30),

            // Loading Indicator
            CircularProgressIndicator(
              color: ColorManager.primaryBlue,
            ),



          ],
        ),
      ),
    );
  }
}



























/*
import 'package:flutter/material.dart';
import 'package:maisys/screens/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) {
            return Welcome();
          })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/svgs/main_logo/Main_Logo.png',
          width:  MediaQuery.of(context).size.width * 0.75,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
*/

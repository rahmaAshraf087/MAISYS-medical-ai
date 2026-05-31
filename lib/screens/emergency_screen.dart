import 'package:flutter/material.dart';
import 'package:maisys/overviews/overviewscreen.dart';

import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kohly,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emergency Icon (Animated)
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0.8, end: 1.2),
                    curve: Curves.easeInOut,
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.red.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      // Loop animation
                    },
                  ),

                  SizedBox(height: 30),

                  // Title
                  Text(
                    'This may be a medical emergency',
                    textAlign: TextAlign.center,
                    style: TextStyles.font28primarybluebold.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Subtitle
                  Text(
                    'Based on your symptoms, please seek immediate medical attention.',
                    textAlign: TextAlign.center,
                    style: TextStyles.font16white600w.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Call Emergency Services Button
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 400),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _callEmergencyServices();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                      ),
                      icon: Icon(
                        Icons.phone,
                        size: 28,
                      ),
                      label: Text(
                        'Call Emergency Services',
                        style: TextStyles.font20whitebold,
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // While waiting for help
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E2A3A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF2D3E50),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'While waiting for help:',
                          style: TextStyles.font16white600w,
                        ),
                        SizedBox(height: 15),
                        _buildBulletPoint('Stay calm and try to remain still'),
                        _buildBulletPoint('If possible, have someone stay with you'),
                        _buildBulletPoint('Gather any relevant medical information'),
                        _buildBulletPoint('Unlock your door if help is on the way'),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Return to Dashboard
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OverviewScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    child: Text(
                      'Return to Dashboard',
                      style: TextStyles.font14whitebold.copyWith(
                        color: ColorManager.primaryBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Disclaimer
                  Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D1F0F),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF8B6914),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'MAISYS cannot provide emergency medical care. Always call local emergency services for medical emergencies.',
                      textAlign: TextAlign.center,
                      style: TextStyles.font12lightgray400w.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyles.font14whitebold.copyWith(
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyles.font14whitebold.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callEmergencyServices() async {
    // TODO: Get emergency number based on user's country
    // For now, using a generic emergency number
    final Uri phoneUri = Uri(scheme: 'tel', path: '123'); // Replace with actual emergency number

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        print('Could not launch emergency call');
      }
    } catch (e) {
      print('Error launching emergency call: $e');
    }
  }
}
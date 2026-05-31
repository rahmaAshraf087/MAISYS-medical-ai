import 'package:flutter/material.dart';
import 'package:maisys/overviews/overviewscreen.dart';

import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class InsufficientInfoScreen extends StatelessWidget {
  const InsufficientInfoScreen({super.key});

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
                  // Info Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: ColorManager.primaryBlue,
                      size: 50,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Title
                  Text(
                    'Insufficient Information',
                    textAlign: TextAlign.center,
                    style: TextStyles.font28primarybluebold.copyWith(
                      color: ColorManager.primaryBlue,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Subtitle
                  Text(
                    'I do not have enough reliable information to provide a safe response to your query.',
                    textAlign: TextAlign.center,
                    style: TextStyles.font16white600w.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: 40),

                  // This might happen because
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
                          'This might happen because:',
                          style: TextStyles.font16white600w,
                        ),
                        SizedBox(height: 15),
                        _buildBulletPoint('The topic requires specialized medical expertise'),
                        _buildBulletPoint('There isn\'t enough verified research on this specific question'),
                        _buildBulletPoint('The question involves complex interactions that require professional evaluation'),
                        _buildBulletPoint('Individual medical conditions affect the answer significantly'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // What you can do
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
                          'What you can do:',
                          style: TextStyles.font16white600w,
                        ),
                        SizedBox(height: 15),
                        _buildBulletPoint('Consult a healthcare professional for personalized advice'),
                        _buildBulletPoint('Try rephrasing your question with more specific details'),
                        _buildBulletPoint('Ask about general concepts rather than specific diagnoses'),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Action Buttons
                  Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate back to ask another question
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryBlue,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Ask Another Question',
                              style: TextStyles.font14whitebold,
                            ),
                          ),
                        ),

                        SizedBox(width: 15),

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OverviewScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: ColorManager.primaryBlue,
                                width: 1,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Return to Dashboard',
                              style: TextStyles.font14whitebold.copyWith(
                                color: ColorManager.primaryBlue,
                              ),
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
}
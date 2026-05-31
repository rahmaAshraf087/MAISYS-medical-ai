import 'package:flutter/material.dart';
import 'package:maisys/medical_tools/chatscreen/pre_chat_screen.dart';
import 'package:maisys/overviews/overviewscreen.dart';

import 'package:maisys/widgets/footer_widget.dart';
import 'package:maisys/widgets/medical_disclaimer_widget.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kohly,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            _buildTopHeader(context),

            // Main Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40),

                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Terms, Policies & Disclaimers',
                          style: TextStyles.font28primarybluebold.copyWith(
                            color: ColorManager.primaryBlue,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Medical Disclaimer Section
                    _buildSection(
                      icon: Icons.warning_amber_rounded,
                      iconColor: Color(0xFFFFB020),
                      title: 'Medical Disclaimer',
                      content: '''MAISYS is an AI-powered medical information system designed for educational purposes only. It is not intended to provide medical diagnoses, treatment recommendations, or replace professional medical advice.

- Always consult qualified healthcare professionals for medical decisions
- Do not use MAISYS for medical emergencies - call emergency services immediately
- Information provided may not be complete or applicable to your specific situation
- Drug interaction checks are for reference only and may not include all possible interactions''',
                    ),

                    SizedBox(height: 20),

                    // Privacy Policy Section
                    _buildSection(
                      icon: Icons.lock_outline,
                      iconColor: ColorManager.primaryBlue,
                      title: 'Privacy Policy',
                      content: '''Your privacy is important to us. Here's how we handle your data:

- Conversations are processed to provide responses but are not permanently stored
- Medical profile information is stored locally on your device
- We do not sell or share your personal information with third parties
- Analytics data is anonymized and used only to improve the service
- You can delete all stored data at any time from your profile settings''',
                    ),

                    SizedBox(height: 20),

                    // AI Limitations Section
                    _buildSection(
                      icon: Icons.psychology_outlined,
                      iconColor: Color(0xFF9B59B6),
                      title: 'AI Limitations',
                      content: '''Understanding the limitations of AI-powered medical information:

- All responses are generated based on training data and may contain errors
- The system cannot account for your complete medical history
- New medical research may not be immediately reflected in responses
- AI cannot perform physical examinations or diagnostic tests
- Cultural and regional medical practices may vary''',
                    ),

                    SizedBox(height: 20),

                    // Data Sources Section
                    _buildSection(
                      icon: Icons.library_books_outlined,
                      iconColor: Color(0xFF3498DB),
                      title: 'Data Sources Transparency',
                      content: '''MAISYS uses information from verified medical sources including:

- Peer-reviewed medical journals and publications
- Clinical practice guidelines from medical associations
- Drug databases and interaction references
- Public health organization guidelines (WHO, CDC, etc.)''',
                    ),

                    SizedBox(height: 20),

                    // User Responsibilities Section
                    _buildSection(
                      icon: Icons.assignment_outlined,
                      iconColor: Color(0xFF27AE60),
                      title: 'User Responsibilities',
                      content: '''By using MAISYS, you agree to:

- Use the service for educational purposes only
- Not rely solely on AI-generated information for medical decisions
- Seek professional medical advice for health concerns
- Report any inaccurate or potentially harmful information
- Accept that the service is provided "as is" without warranties''',
                    ),

                    SizedBox(height: 40),

                    // Footer
                    FooterWidget(),

                    SizedBox(height: 20),

                    // Medical Disclaimer
                    MedicalDisclaimerWidget(),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top Header
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E2A3A),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2D3E50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MAISYS Logo
          Image.asset(
            "assets/svgs/appbar_logo/WhiteLogo.png",
            width: 120,
            height: 40,
          ),

          // Top Navigation Icons
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: _buildNavIcon(Icons.arrow_back, false),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OverviewScreen(),
                    ),
                  );
                },
                child: _buildNavIcon(Icons.home_outlined, false),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreChatScreen(),
                    ),
                  );
                },
                child: _buildNavIcon(Icons.chat_bubble_outline, false),
              ),
              SizedBox(width: 10),
              _buildNavIcon(Icons.settings_outlined, false),
              SizedBox(width: 10),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: ColorManager.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primaryBlue : Color(0xFF2D3E50),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  // Section Widget
  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
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
            // Icon and Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.font20whitebold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Content
            Text(
              content,
              style: TextStyles.font14whitebold.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.normal,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
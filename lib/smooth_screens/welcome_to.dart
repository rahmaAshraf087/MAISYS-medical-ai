import 'package:flutter/material.dart';
import 'package:maisys/theme/style_helper.dart';

class WelcomeTo extends StatelessWidget {
  final String emoji;
  final String title;
  final String descr;
  final VoidCallback onpresed;

  const WelcomeTo({
    super.key,
    required this.emoji,
    required this.title,
    required this.descr,
    required this.onpresed
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji Section (فقط للصفحة الأولى)
              Text(
                emoji,
                style: TextStyle(fontSize: 60),
              ),
              SizedBox(height: 25),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.font28primarybluebold,
            ),

            SizedBox(height: 20),

            // Description
            Text(
              descr,
              textAlign: TextAlign.center,
              style: TextStyles.font16white600w,
            ),

            Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onpresed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BCD4), // Cyan color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Next",
                  style: TextStyles.font16white600w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class Capabilities extends StatelessWidget {
  final VoidCallback onNext;

  const Capabilities({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.58 - 20 ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  "Core Capabilities",
                  textAlign: TextAlign.center,
                  style: TextStyles.font28primarybluebold,
                ),
                SizedBox(height: 15),
                // Cards Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Row of Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CapabilityCard(
                          emoji: "💬",
                          title: "Medical AI chatbot",
                          descr: "Verified medical sources.",
                        ),
                        CapabilityCard(
                          emoji: "💊",
                          title: "Drug interaction",
                          descr: "Check medication safety.",
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Second Row of Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CapabilityCard(
                          emoji: "🧪",
                          title: "Lab test results",
                          descr: "Understand results clearly.",
                        ),
                        CapabilityCard(
                          emoji: "📄",
                          title: "Research papers",
                          descr: "Analyze medical research.",
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00BCD4), // Cyan color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Next",
                      style:  TextStyles.font16white600w,
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CapabilityCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String descr;

  const CapabilityCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.descr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorManager.cardscontainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Emoji
          Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 5),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font18white600w,
          ),
          SizedBox(height: 3),
          // Description
          Text(
            descr,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font16white600w,
          ),
        ],
      ),
    );
  }
}
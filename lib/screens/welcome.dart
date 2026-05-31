

import 'package:flutter/material.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/smooth_screens/capabilities.dart';
import 'package:maisys/smooth_screens/warning.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:maisys/smooth_screens/welcome_to.dart';










class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _controller = PageController();
  int currentPage = 0;

  void goTonext(){
    if(currentPage < 3){
      _controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Login()
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kohly,
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 70,
                      height: 70,
                      child: Image(image: AssetImage("assets/svgs/appbar_logo/WhiteLogo.png")))
                ],
              ),
            ),

            const Spacer(),

            // Page Indicator - خارج الـ Container
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                textDirection: TextDirection.ltr,
                effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xFF00BCD4), // Cyan color
                  dotColor: ColorManager.gray,
                  dotHeight: 7,
                  dotWidth: 7,
                  spacing: 8,
                  expansionFactor: 3,
                ),
              ),
            ),

            // Main Content Container
            Container(
              width: MediaQuery.of(context).size.width * 0.88,
              height: MediaQuery.of(context).size.height * 0.58,
              decoration: BoxDecoration(
                color: Color(0xFF2D3748), // Dark gray - يمكنك تعديله
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index){
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    WelcomeTo(
                      emoji : "👋",
                      title: "Welcome to MAISYS",
                      descr: "MAISYS is an AI-powered medical assistant designed to help users understand health information safely and clearly using trusted medical sources.",
                      onpresed: goTonext,
                    ),
                    WelcomeTo(
                      emoji: "💬",
                      title: "Chat Anytime",
                      descr: "Ask questions about symptoms, medications, or general health topics.\nMAISYS is here to provide guidance 24/7.",
                      onpresed: goTonext,
                    ),
                    Capabilities(
                      onNext: goTonext,
                    ),
                    Warning(),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom Text
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Educational medical assistance — not a doctor",
                style: TextStyles.font12lightgray400w.copyWith(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
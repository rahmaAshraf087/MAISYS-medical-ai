
import 'package:flutter/material.dart';
import 'package:maisys/screens/login.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class Warning extends StatefulWidget {
  const Warning({super.key});

  @override
  State<Warning> createState() => _WarningState();
}

class _WarningState extends State<Warning> {
  bool isAgreed = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.58 - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Safety & Consent",
                style: TextStyles.font28primarybluebold,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("⚠️"),
                      SizedBox(width: 16),
                      Text("MAISYS does not diagnose \ndiseases, prescribe treatments, \nor replace healthcare professionals\nor emergency services.",
                      style: TextStyles.font14whitebold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: ColorManager.kohly,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    value: isAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        isAgreed = value ?? false;
                      });
                    },
                    title: Text(
                      'I understand and agree to the medical disclaimer and terms',
                      style: TextStyles.font14whitebold,
                    ),
                    activeColor: Color(0xFF4FC3F7),
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Spacer(),
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isAgreed ? () {
                    // Navigate to next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4FC3F7),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: Text('Get Started',
                  style: TextStyles.font16white600w,
                  ),
                ),
              ],
            ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}






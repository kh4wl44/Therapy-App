import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/signup.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lati_project/features/auth/screens/Register/userType.dart';


class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
  }

class _LandingPageState extends State<LandingPage>{


  @override
  void initstate() {
    super.initState();
  }

  int opacity = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color(0xffFB86AF),
              Color(0xffF4A1BE),
              Color(0xffBF75D4),
              Color(0xff9064F4),
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: 1,
                duration: Duration(seconds: 2),
                child: Text("بلا حواجز", style: GoogleFonts.almarai(
                            textStyle: TextStyle(fontSize: 35, color: Colors.white),),),
              ),

              // AnimatedTextKit(
              //   animatedTexts: [
              //     TypewriterAnimatedText(
              //       'بلا حواجز',
              //       textStyle: const TextStyle(
              //         fontSize: 32.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //       speed: const Duration(milliseconds: 2000),
              //     ),
              //   ],
              //
              //   totalRepeatCount: 4,
              //   pause: const Duration(milliseconds: 500),
              //   displayFullTextOnTap: true,
              //   stopPauseOnTap: true,
              // ),
              // TweenAnimationBuilder(
              //   tween: Tween<double>(begin: 1.0, end: 30.0),
              //   duration: Duration(seconds: 2),
              //   builder: (BuildContext context, double value, Widget? child) {
              //     return Text("بلا حواجز", style: GoogleFonts.almarai(
              //       textStyle: TextStyle(fontSize: value, color: Colors.white),),);
              //   },
              // ),

              Column(
                children: [
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(()=>UserType());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff103D78),
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('تسجيل دخول',
                      style: GoogleFonts.almarai(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(()=>UserType());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff561789),
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('إنشاء حساب',
                      style: GoogleFonts.almarai(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/userType.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart'; // Import your main content page
import 'package:lati_project/features/auth/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lati_project/api/registration_controller.dart';
class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double _opacity = 1.0; // Initial opacity

  @override
  void initState() {
    super.initState();
    // Start the fade-out effect and navigate after 3 seconds
    Timer(Duration(seconds: 4), () {
      setState(() {
        _opacity = 0.0; // Fade out the text
      });
      // Navigate after the fade-out animation duration
      Timer(Duration(seconds: 2), () {
       checkLoginStatus(); // Navigate to the next screen
      });
    });
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
       final registrationController = Get.find<RegistrationController>();
    bool isRegistrationComplete = await registrationController.isRegistrationComplete();
    
    if (isRegistrationComplete)
    {
      Get.offAll(() => HomePage()); // Replace with your main content page
    } else
    {
       Get.offAll(() => ClientTypes());
    }}
    
    else {
      // User is not logged in, navigate to UserType page
      Get.to(() => UserType());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
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
                opacity: _opacity,
                duration: Duration(seconds: 1), // Duration for fade-out
                child: Text(
                  "بدون حواجز",
                  style: GoogleFonts.almarai(
                    textStyle: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
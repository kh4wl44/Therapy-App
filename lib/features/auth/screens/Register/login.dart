import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/signup.dart';
import 'package:get/get.dart';

import 'forgetpassword.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         // appBar: AppBar(
         //   automaticallyImplyLeading: false,
         //   backgroundColor: Color(0xffF4A1BE),
         //   title: Text("رجوع", style: GoogleFonts.almarai(color: Colors.white),
         //   ),
         // ),

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView( // Allows scrolling if content overflows
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Take minimum space
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.almarai(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                    Center(
                      child: Container(
                        width: 350,
                        child: TextField(
                          style: GoogleFonts.almarai(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: "البريد الإلكتروني",
                            hintStyle: TextStyle(color: Color(0xff595959)),
                            prefixIcon: const Icon(Icons.person, color: Color(0xff595959)),
                            filled: true, // Enable filling
                            fillColor: Colors.white54,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white54), // border color when enabled
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.purple), // border color when focused
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red), // Border color when there's an error
                            ),
                          ),
                        ),
                      ),
                    ),
                        const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 350,
                        child: TextField(
                          style: GoogleFonts.almarai(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: "كلمة السر",
                            hintStyle: TextStyle(color: Color(0xff595959)),
                            prefixIcon: const Icon(Icons.lock, color: Color(0xff595959)),
                            filled: true, // Enable filling
                            fillColor: Colors.white54, // Set background color to white
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white54), // border color when enabled
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.purple), // border color when focused
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red), // Border color when there's an error
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0), // Adjust the left padding as needed
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => ForgetPassword());
                        },
                        child: Text(
                          'نسيت كلمة السر؟',
                          style: GoogleFonts.almarai(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                        const SizedBox(height: 15),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle login logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff103D78),
                              minimumSize: Size(double.minPositive, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text('تسجيل الدخول',
                              style: GoogleFonts.almarai(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // TextButton(
                        //   onPressed: () {
                        //     // Navigate to forgot password screen or logic
                        //   },
                        //   child: Text(
                        //     'نسيت كلمة السر؟',
                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                    Center(child: Text("ليس لديك حساب؟",
                        style: GoogleFonts.almarai(
                            color: Colors.white,
                            fontSize: 18))),
                    TextButton(
                      onPressed: () {
                        Get.to(()=>Signup());
                      },
                          child: Center(
                            child: Center(
                              child: Text(
                                'قم بإنشاء حساب جديد', // Add \n to create a new line
                                textAlign: TextAlign.center,
                                style: GoogleFonts.almarai(color: Color(0xff103D78), fontSize: 18),
                              ),
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
}
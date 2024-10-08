import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/signup.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _loginState();
}

class _loginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
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
                                'بدون حواجز',
                                style: GoogleFonts.almarai(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
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
                    TextField(
                      style: GoogleFonts.almarai(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "البريد الإلكتروني",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white), // border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.purple), // border color when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red), // Border color when there's an error
                        ),
                      ),
                    ),
                        const SizedBox(height: 16),
                    TextField(
                      style: GoogleFonts.almarai(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "كلمة السر",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white), // border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.purple), // border color when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red), // Border color when there's an error
                        ),
                      ),
                    ),
                        TextButton(
                          onPressed: () {
                            // Navigate to forgot password screen or logic
                          },
                          child: Text(
                            'هل نسيت كلمة السر؟',
                            style: GoogleFonts.almarai(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            // Handle login logic
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('تسجيل الدخول',
                            style: GoogleFonts.almarai(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
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
                    TextButton(
                      onPressed: () {
                        Get.to(()=>Signup());
                      },
                          child: Center(
                            child: Center(
                              child: Text(
                                'ليس لديك حساب؟\nقم بإنشاء حساب جديد', // Add \n to create a new line
                                textAlign: TextAlign.center,
                                style: GoogleFonts.almarai(color: Colors.white, fontSize: 20),
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
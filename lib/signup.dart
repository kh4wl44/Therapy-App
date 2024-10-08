import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
                          'إنشاء حساب',
                          style: GoogleFonts.almarai(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: GoogleFonts.almarai(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "البريد الإلكتروني",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.mail, color: Colors.white),
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


                  const SizedBox(height: 20),
                  TextField(
                    style: GoogleFonts.almarai(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "اسم المستخدم",
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
                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),
                  TextField(
                    style: GoogleFonts.almarai(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "تأكيد كلمة السر",
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

                  const SizedBox(height: 40),
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
                    child: Text('إنشاء حساب',
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
                      Get.off(Login());
                    },
                    child: Center(
                      child: Center(
                        child: Text(
                          'لديك حساب بالفعل؟\nقم بتسجيل الدخول', // Add \n to create a new line
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
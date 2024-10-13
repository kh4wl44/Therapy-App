import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';

import 'login.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.only(bottom: 15.0),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      hintStyle: TextStyle(color: Color(0xff595959)),
                      prefixIcon: const Icon(Icons.mail, color: Color(0xff595959)),
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


                  const SizedBox(height: 20),
                  TextField(
                    style: GoogleFonts.almarai(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "اسم المستخدم",
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
                      hintStyle: TextStyle(color: Color(0xff595959)),
                      prefixIcon: const Icon(Icons.lock, color: Color(0xff595959)),
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

                  const SizedBox(height: 20),
                  TextField(
                    style: GoogleFonts.almarai(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "تأكيد كلمة السر",
                      hintStyle: TextStyle(color: Color(0xff595959)),
                      prefixIcon: const Icon(Icons.lock, color: Color(0xff595959)),
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

                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>ClientTypes());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff561789),
                        minimumSize: Size(double.minPositive, 50),
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
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 20),
                  Center(child: Text("لديك حساب بالفعل؟",
                      style: GoogleFonts.almarai(
                          color: Colors.white,
                          fontSize: 18))),
                  TextButton(
                    onPressed: () {
                      Get.off(Login());
                    },
                    child: Center(
                      child: Center(
                        child: Text(
                          'قم بتسجيل الدخول', // Add \n to create a new line
                          textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(color: Color(0xff561789), fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  //BackButton(color: Colors.white,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
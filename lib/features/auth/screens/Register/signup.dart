import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lati_project/api/api_service.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';
import 'login.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Signup extends StatefulWidget {

  final bool? isTherapist;

   const Signup({super.key, required this.isTherapist});
    
    @override
   State<Signup> createState() => SignupState();
}



class SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();
      
      Future<void> saveUserInfo(String name, String email, bool isTherapist ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true);
    await prefs.setBool('is_therapist', isTherapist);
  }

 


      void _handleSignup() async {



    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    

    if (emailController.text.isEmpty || 
        usernameController.text.isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    
      final userRequest = UserSignUpRequest(
      name: usernameController.text, // Assuming username is used as name
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      isTherapist: false, // Set this based on user selection if applicable
    );

    final result = await _apiService.signupUser(userRequest);

    if (result['success']) {
      await saveUserInfo(usernameController.text, emailController.text, widget.isTherapist ?? false);
      Get.snackbar('Success', result['message']);
      Get.to(() => ClientTypes());
    } else {
      Get.snackbar('Error', result['message']);
      if (result['statusCode'] == 400) {
        print('There was a problem with the data sent to the server. Please check your inputs.');
      }
    }
  }

  // Reusable TextField widget
  Widget buildTextField(String hintText, IconData prefixIcon, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.almarai(fontSize: 20),

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xff838282)),
        prefixIcon: Icon(prefixIcon, color: Color(0xff838282)),
        filled: true,
        fillColor: Colors.white54,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white54),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.purple),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'إنشاء حساب',
                      style: GoogleFonts.almarai(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextField("البريد الإلكتروني", Icons.mail, controller: emailController),
                  const SizedBox(height: 20),
                  buildTextField("اسم المستخدم", Icons.person, controller: usernameController),
                  const SizedBox(height: 20),
                  buildTextField("كلمة السر", Icons.lock, obscureText: true, controller: passwordController),
                  const SizedBox(height: 20),
                  buildTextField("تأكيد كلمة السر", Icons.lock, obscureText: true, controller: confirmPasswordController),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed:  _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff561789),
                        minimumSize: Size(double.minPositive, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'إنشاء حساب',
                        style: GoogleFonts.almarai(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "لديك حساب بالفعل؟",
                      style: GoogleFonts.almarai(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.off(Login());
                      },
                      child: Text(
                        'قم بتسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(color: Color(0xff561789), fontSize: 18),
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


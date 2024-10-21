import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lati_project/api/api_service.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';
import '../Therapist/TherapistHome.dart';
import '../home_page.dart';
import 'login.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Signup extends StatefulWidget {

  final bool? isTherapist;

   const Signup({super.key, required this.isTherapist});
    
    @override
   State<Signup> createState() => SignupState();
}


final Logger _logger = Logger();
class SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late final ApiService _apiService;
      

      
  @override
  void initState() {
    super.initState();
    _apiService = Get.find<ApiService>();
  }

      Future<void> saveUserInfo(String name, String email, bool isTherapist ) async {
        try{
    final prefs = await SharedPreferences.getInstance();
    bool nameSaved = await prefs.setString('user_name', name);
    _logger.i('user_name saved: $nameSaved');
    
    bool emailSaved = await prefs.setString('user_email', email);
    _logger.i('user_email saved: $emailSaved');
    
    bool loggedInSaved = await prefs.setBool('is_logged_in', true);
    _logger.i('is_logged_in saved: $loggedInSaved');
    
    bool therapistSaved = await prefs.setBool('is_therapist', isTherapist);
    _logger.i('is_therapist saved: $therapistSaved');

    // Check if all saves were successful
    if (nameSaved && emailSaved && loggedInSaved && therapistSaved) {
      _logger.i('All user info saved successfully');
      
    } else {
      _logger.i('Some user info failed to save');
      
  }} catch (e) {
    _logger.i('Error saving user info: $e');
    
  }
    
  }

 
 Future<void> checkSavedInfo() async {
  final prefs = await SharedPreferences.getInstance();
  _logger.i('Checking saved user info:');
  _logger.i('Saved user name: ${prefs.getString('user_name')}');
  _logger.i('Saved user email: ${prefs.getString('user_email')}');
  _logger.i('Is logged in: ${prefs.getBool('is_logged_in')}');
  _logger.i('Is therapist: ${prefs.getBool('is_therapist')}');
}

      void _handleSignup() async {



    if (passwordController.text != confirmPasswordController.text) {
       Get.snackbar('Error', 'كلمات المرور غير متطابقة');
      return;
    }

    

    if (emailController.text.isEmpty || 
        usernameController.text.isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'الرجاء ملء جميع الحقول',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'الرجاء إدخال عنوان بريد إلكتروني صالح');
    }

    
      final userRequest = UserSignUpRequest(
      name: usernameController.text, // Assuming username is used as name
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      isTherapist:widget.isTherapist ?? false, // Set this based on user selection if applicable
    );

    final result = await _apiService.signupUser(userRequest);

    if (result['success']) {
      _logger.i('signup success, attempting to save user info');
      await saveUserInfo(usernameController.text, emailController.text, widget.isTherapist ?? false);
      await checkSavedInfo();
      Get.snackbar('Success', result['message']);
      Get.to(() => ClientTypes());
    } else {
      _logger.i('Error response: ${result['message']}');
      Get.snackbar('Error', result['message']);
      if (result['statusCode'] == 400) {
        _logger.i('There was a problem with the data sent to the server. Please check your inputs.');
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
                        Get.off(TherapistHome());
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


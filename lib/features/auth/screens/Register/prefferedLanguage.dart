import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';
import '../../../../api/registration_controller.dart';
import '../home_page.dart';

class PrefferedLanguage extends StatelessWidget {
  final RegistrationController controller = Get.find<RegistrationController>();

  PrefferedLanguage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF4A1BE),
        title: Text(
          "4/4",
          style: GoogleFonts.almarai(
            textStyle: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Text(
                  "ما اللغة التي تفضل التحدث بها مع المعالج؟",
                  style: GoogleFonts.almarai(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              CustomButton('العربية', 'ar'),
              SizedBox(height: 20),
              CustomButton('English', 'en'),
              SizedBox(height: 40),
              SizedBox(height: 260),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.sendClientPreferences();
                    Get.to(() => HomePage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff561789),
                    minimumSize: Size(double.minPositive, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'التالي',
                    style: GoogleFonts.almarai(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

class CustomButton extends StatefulWidget {
  final String title;
  final String language;
  CustomButton(this.title, this.language);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller =
        Get.find<RegistrationController>();
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isPressed = !isPressed; // Toggle the pressed state
        });
        controller.updateLanguagePreference(widget.language);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(350, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: isPressed ? Colors.purple : Colors.white,
        foregroundColor: isPressed ? Colors.white : Colors.deepPurple,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          widget.title,
          style: GoogleFonts.almarai(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

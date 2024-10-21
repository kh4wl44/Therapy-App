import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../api/registration_controller.dart';
import 'MaleOrFemale.dart';

class ClientTypes extends StatelessWidget {
  final RegistrationController controller = Get.find<RegistrationController>();

  ClientTypes({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF4A1BE),
        title: Text(
          "4/1",
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "ما نوع الجلسات التي تحتاجها؟",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.almarai(
                      textStyle: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              CustomButton(
                title: 'جلسات إنفرادية',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                  controller.updateSessionType('جلسات فردية');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات مخصصة للأزواج',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                  controller.updateSessionType('جلسات للأزواج');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات لطفلي',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                  controller.updateSessionType('جلسات للأطفال');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات عائلية',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                  controller.updateSessionType('جلسات عائلية');
                },
              ),
              const SizedBox(height: 195),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => MaleOrFemale());
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
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  CustomButton({required this.title, required this.onPressed});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isPressed = !isPressed; // Toggle the pressed state
        });
        widget.onPressed(); // Call the passed onPressed function
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
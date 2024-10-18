import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/chooseTopicsToShare.dart';
import 'ClientTypes.dart';

class MaleOrFemale extends StatelessWidget {

   final RegistrationController controller = Get.find<RegistrationController>();

    MaleOrFemale({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF4A1BE),
        title: Text(
          "4/2",
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
                  "هل أنت؟",
                  style: GoogleFonts.almarai(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),

              CustomButton( 'أنثى',
                isSelected: controller.gender.value == 'female',
                onPressed: () => controller.updateGender('female'),
              ),
              SizedBox(height: 20),
              CustomButton( 'ذكر',
                isSelected: controller.gender.value == 'male',
                onPressed: () => controller.updateGender('male'),
              ),
              SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "وما المعالج الذي تفضله؟",
                  style: GoogleFonts.almarai(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton('لا تفضيل',
                isSelected: controller.therapistPreference.value == 'any',
                onPressed: () => controller.updateTherapistPreference('any'),
              ),
              SizedBox(height: 20),
              CustomButton(  'امرأة',
                isSelected: controller.therapistPreference.value == 'female',
                onPressed: () => controller.updateTherapistPreference('female'),
              ),
              SizedBox(height: 20),
              CustomButton( 'رجل',
                isSelected: controller.therapistPreference.value == 'male',
                onPressed: () => controller.updateTherapistPreference('male'),),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  if (controller.gender.value.isNotEmpty && controller.therapistPreference.value.isNotEmpty) {
                      Get.to(() => ChooseTopicsToShare());
                    } else {
                      Get.snackbar('Error', 'Please select your gender and therapist preference');
                    }
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

class CustomButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  CustomButton(this.title, {required this.isSelected, required this.onPressed});




  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      
      style: ElevatedButton.styleFrom(
        minimumSize: Size(350, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: isSelected ? Colors.purple : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: GoogleFonts.almarai(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
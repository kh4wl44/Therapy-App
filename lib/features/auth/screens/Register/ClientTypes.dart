import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../api/api_service.dart';
import 'MaleOrFemale.dart';


class RegistrationController extends GetxController {
  late ApiService apiService;
  

   final RxString sessionType = ''.obs;
  final RxString gender = ''.obs;
  final RxString therapistPreference = ''.obs;
  final RxString languagePreference = ''.obs;
  final RxList<String> topics = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    apiService = Get.find<ApiService>();
  }


   Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    sessionType.value = prefs.getString('sessionType') ?? '';
    gender.value = prefs.getString('gender') ?? '';
    therapistPreference.value = prefs.getString('therapistPreference') ?? '';
    topics.value = prefs.getStringList('topics') ?? [];
    languagePreference.value = prefs.getString('languagePreference') ?? '';
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionType', sessionType.value);
    await prefs.setString('gender', gender.value);
    await prefs.setString('therapistPreference', therapistPreference.value);
    await prefs.setStringList('topics', topics);
    await prefs.setString('languagePreference', languagePreference.value);
  }


  void updateTherapistPreference(String preference) {
    therapistPreference.value = preference;
  }

  

  void updateSessionType(String type) {
    sessionType.value = type;
  }

  void updateGender(String selectedGender) {
    gender.value = selectedGender;
  }

  

  void updateLanguagePreference(String language) {
    languagePreference.value = language;
  }

  // Add other update methods as needed

  Future<void> sendClientPreferences() async {
    if (sessionType.isEmpty || gender.isEmpty || therapistPreference.isEmpty || topics.isEmpty || languagePreference.isEmpty) {
      Get.snackbar('Error', 'Please complete all required fields');
      return;
    }

    
    try {
       final userPreferences = UserPreferences(
        sessionType: sessionType.value,
        gender: gender.value,
        therapistPreference: therapistPreference.value,
          languagePreference: languagePreference.value,
         topics:topics,
        // ... other fields ...
      );
      
      final token = await getAuthToken();
      
      final result = await apiService.sendClientPreferences(userPreferences, token);
      
       if (result['success']) {
        Get.snackbar('Success', 'Preferences updated successfully');
        // Clear preferences after successful submission
        await savePreferences();
        await setRegistrationComplete();
        // Navigate to the home screen or dashboard
        // Get.offAll(() => HomePage());
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update preferences');
    }
  }
    Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionType');
    await prefs.remove('gender');
    await prefs.remove('therapistPreference');
    await prefs.remove('topics');
    await prefs.remove('languagePreference');
  
  

   sessionType.value = '';
    gender.value = '';
    therapistPreference.value = '';
    topics.clear();
    languagePreference.value = '';
  }

  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  

  Future<bool> isRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('registration_complete') ?? false;
  }

  Future<void> setRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('registration_complete', true);
  }
}




class ClientTypes extends StatelessWidget {
 const ClientTypes({super.key});

  

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
                    controller.updateSessionType('individual');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات مخصصة للأزواج',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                    controller.updateSessionType('couples');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات لطفلي',
                onPressed: () {
                  final controller = Get.find<RegistrationController>();
                  controller.updateSessionType('child');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'جلسات عائلية',
                onPressed: () {
                    final controller = Get.find<RegistrationController>();
                    controller.updateSessionType('family');
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

import 'package:flutter/material.dart';

import 'package:lati_project/api/api_service.dart';
import 'package:lati_project/features/auth/screens/Client/ClientSearchScreen.dart';
import 'package:lati_project/features/auth/screens/Register/landingpage.dart';
import 'package:lati_project/features/auth/screens/Register/login.dart';
import 'package:lati_project/features/auth/screens/Register/signup.dart';
import 'package:lati_project/features/auth/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';
import 'package:lati_project/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/registration_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  // Initialize RegistrationController
  final registrationController = Get.put(RegistrationController());

  // Initialize ApiService with RegistrationController
  final apiService = Get.put(ApiService(registrationController));

  // Set up the callback
  registrationController.sendPreferencesCallback =
      apiService.sendClientPreferences;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: TextTheme(GoogleFonts.abel),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: GlobalTheme().getTheme(),
      home: SearchScreen(),
    );
  }
}

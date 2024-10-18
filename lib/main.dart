import 'package:flutter/material.dart';

import 'package:lati_project/api/api_service.dart';
import 'package:lati_project/features/auth/screens/Register/landingpage.dart';
import 'package:lati_project/features/auth/screens/home_page.dart'; 
import 'package:get/get.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.put(ApiService());
  Get.put(RegistrationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context){
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: TextTheme(GoogleFonts.abel),
        builder: (context, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      );
    },
      home: LandingPage(),
  );
}}


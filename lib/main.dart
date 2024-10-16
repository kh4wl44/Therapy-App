import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lati_project/features/auth/screens/Register/landingpage.dart';


import 'features/auth/screens/Register/login.dart';

void main() {
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


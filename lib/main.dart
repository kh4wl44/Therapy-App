import 'package:flutter/material.dart';

import 'package:lati_project/api/api_service.dart';
import 'package:lati_project/features/auth/screens/Register/landingpage.dart';

import 'package:get/get.dart';


void main() async{
   Get.put(ApiService());
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


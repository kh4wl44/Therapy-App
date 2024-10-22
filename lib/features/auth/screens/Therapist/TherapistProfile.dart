import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lati_project/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TherapistDetails.dart'; // Import the TherapistDetails class

class TherapistProfile extends StatefulWidget {
  @override
  State<TherapistProfile> createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile> {
  String therapistName = "";
  String username = "";
  String email = "";
  String profileImage = "assets/profile.png"; // Replace with your image asset path

  @override
  void initState() {
    super.initState();
    _loadTherapistInfo();
  }

  Future<void> _loadTherapistInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //therapistName = prefs.getString('user_name') ?? "Unknown Name";
      username = prefs.getString('user_username') ?? "Unknown Username";
      email = prefs.getString('user_email') ?? "Unknown Email";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الشخصية", style: GoogleFonts.almarai(color: Colors.white)),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImage), // Load the profile image
              ),
            ),
            SizedBox(height: 16),
            // Therapist Name
            // Center(
            //   child: Text(
            //     therapistName,
            //     style: GoogleFonts.almarai(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(height: 8),
            // Therapist Username
            Center(
              child: Text(
                username,
                style: GoogleFonts.almarai(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            // Email
            Center(
              child: Text(
                email,
                style: GoogleFonts.almarai(fontSize: 18, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            // Edit Details Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //Get.to(() => TherapistDetails());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: Size(double.minPositive, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "تعديل التفاصيل",
                  style: GoogleFonts.almarai(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
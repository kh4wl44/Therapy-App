import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'JournalsScreen.dart';
import 'WriteJournal.dart';
// import 'journal_screen.dart'; // Adjust the import path as necessary
// import 'write_journal.dart'; // Adjust the import path as necessary

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final String imageUrl = "https://via.placeholder.com/150"; // Replace with actual user image URL
  final String userName = "اسم المستخدم"; // Replace with actual username
  final String email = "user@example.com"; // Replace with actual email
  final String displayName = "اسمك هنا"; // Replace with actual display name

  List<String> journals = []; // Initialize with an empty list

  void _navigateToWriteJournal() async {
    // Navigate to the Write Journal screen and wait for the result
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WriteJournal(),
      ),
    );

    // Check if the new entry is not null and add it to the journals list
    if (newEntry != null && newEntry is String) {
      setState(() {
        journals.add(newEntry);
      });
    }
  }

  void _navigateToJournalScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JournalScreen(journals: journals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي", style: GoogleFonts.almarai(color: Color(0xff5A3D5C))),
        backgroundColor: Color(0xffF4D7F4),
        iconTheme: IconThemeData(color: Color(0xff5A3D5C)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // صورة المستخدم
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/images/download (1).jpg'), // Use AssetImage directly
              ),
              SizedBox(height: 20),

              // الاسم
              Text(
                displayName,
                style: GoogleFonts.almarai(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5A3D5C),
                ),
              ),
              SizedBox(height: 10),

              // اسم المستخدم
              Text(
                "اسم المستخدم: $userName",
                style: GoogleFonts.almarai(fontSize: 16),
              ),
              SizedBox(height: 5),

              // البريد الإلكتروني
              Text(
                "البريد الإلكتروني: $email",
                style: GoogleFonts.almarai(fontSize: 16),
              ),
              SizedBox(height: 30),


            ],
          ),
        ),
      ),
    );
  }
}
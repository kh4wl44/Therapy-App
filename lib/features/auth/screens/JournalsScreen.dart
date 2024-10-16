import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalScreen extends StatelessWidget {
  final List<String> journals;

  JournalScreen({required this.journals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اليوميات", style: GoogleFonts.almarai()),
        backgroundColor: Color(0xffF4D7F4),
      ),
      body: journals.isEmpty
          ? Center(
        child: Text(
          "لا توجد يوميات بعد",
          style: GoogleFonts.almarai(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: journals.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(journals[index], style: GoogleFonts.almarai()),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

class WriteJournal extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // Controller to retrieve text

  @override
  Widget build(BuildContext context) {
    // Get the current date and time
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("يومياتك", style: GoogleFonts.almarai(textStyle: TextStyle(color: Color(0xff5A3D5C)))),
        backgroundColor: Color(0xffF4D7F4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "كيف تشعر اليوم؟",
              style: GoogleFonts.almarai(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff5A3D5C),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "التاريخ والوقت: $formattedDate",
              style: GoogleFonts.almarai(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'اكتب أفكارك هنا...',
                hintStyle: GoogleFonts.almarai(color: Colors.grey.shade600, fontSize: 18),
                filled: true,
                fillColor: Color(0xffF2EFF3),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String text = _controller.text;
                  if (text.isNotEmpty) {
                    Navigator.of(context).pop(text); // Return the journal entry
                  }
                },
                child: Text("حفظ", style: GoogleFonts.almarai(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff5A3D5C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
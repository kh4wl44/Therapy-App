import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteNotes extends StatelessWidget {
  final String? note; // Optional note for editing
  final TextEditingController _controller = TextEditingController(); // Controller for text input

  WriteNotes({Key? key, this.note}) : super(key: key) {
    if (note != null) {
      _controller.text = note!; // Pre-fill with existing note content
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اكتب ملاحظاتك",
          style: GoogleFonts.almarai(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اكتب ملاحظاتك العامة:",
              style: GoogleFonts.almarai(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
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
                hintText: 'اكتب ملاحظاتك هنا...',
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
                    // Return the note to the previous screen
                    Navigator.of(context).pop(text);
                  }
                },
                child: Text("حفظ", style: GoogleFonts.almarai(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
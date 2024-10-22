import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'WriteNotes.dart';

class GeneralNotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneralNotesState();
}

class _GeneralNotesState extends State<GeneralNotes> {
  List<Note> notes = []; // List to hold notes

  void _updateNote(int index) async {
    final String? editedNote = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WriteNotes(note: notes[index].content), // Pass the note content for editing
      ),
    );
    if (editedNote != null && editedNote.isNotEmpty) {
      setState(() {
        notes[index].content = editedNote; // Update the note content
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الملاحظات",
          style: GoogleFonts.almarai(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: notes.isEmpty
          ? Center(
        child: Text(
          "لا توجد ملاحظات بعد.",
          style: GoogleFonts.almarai(fontSize: 20, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                notes[index].content,
                style: GoogleFonts.almarai(),
              ),
              subtitle: Text(
                "تاريخ: ${notes[index].timestamp}",
                style: GoogleFonts.almarai(fontSize: 12, color: Colors.grey),
              ),
              onTap: () => _updateNote(index), // Open note for editing
            ),
          );
        },
      ),
    );
  }
}

class Note {
  String content;
  DateTime timestamp;

  Note({
    required this.content,
    required this.timestamp,
  });
}
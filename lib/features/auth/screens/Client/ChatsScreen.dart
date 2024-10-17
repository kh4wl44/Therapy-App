import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'SearchScreen.dart'; // Import GetX for navigation

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample chat data
    final List<String> chats = []; // Start with an empty list

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الدردشات',
          style: GoogleFonts.almarai(color: Colors.white), // Chats title
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: chats.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.purple,
            ),
            SizedBox(height: 20), // Space between icon and text
            Text(
              'لا توجد دردشات بعد.',
              style: GoogleFonts.almarai(
                fontSize: 20,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10), // Space between text and instruction
            Text(
              'اضغط على زر "+" لبدء دردشة جديدة.',
              style: GoogleFonts.almarai(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text('U${index + 1}', style: TextStyle(color: Colors.white)),
              ),
              title: Text(
                'محادثة مع المستخدم ${index + 1}', // Chat title
                style: GoogleFonts.almarai(fontSize: 18),
              ),
              subtitle: Text(
                'آخر رسالة من المستخدم ${index + 1}',
                style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              onTap: () {
                // Handle tap on the chat item
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SearchScreen()); // Navigate to SearchScreen
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
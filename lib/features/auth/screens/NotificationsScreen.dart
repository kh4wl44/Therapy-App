import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Start with an empty list of notifications
    final List<String> notifications = []; // No notifications initially

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: GoogleFonts.almarai(color: Colors.white), // Notifications title
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.purple,
            ),
            SizedBox(height: 20), // Space between icon and text
            Text(
              'لا توجد إشعارات بعد.',
              style: GoogleFonts.almarai(
                fontSize: 20,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10), // Space between text and instruction
            Text(
              'سيتم عرض الإشعارات هنا.',
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
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                notifications[index], // Notification message
                style: GoogleFonts.almarai(fontSize: 18),
              ),
              onTap: () {
                // Handle tap on the notification item
              },
            ),
          );
        },
      ),
    );
  }
}
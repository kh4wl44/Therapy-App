import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Therapist/TherapistNotifs.dart';
import 'package:lati_project/features/auth/screens/Therapist/TherapistProfile.dart';
import 'package:lati_project/features/auth/screens/Therapist/TherapistsSessions.dart';

import '../Client/NotificationsScreen.dart';
import 'TherapistChats.dart';
import 'TherapistClients.dart';
import 'GeneralNotes.dart';
import 'WriteNotes.dart';

class TherapistHome extends StatefulWidget {
  @override
  State<TherapistHome> createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key for the scaffold
  final String username = "محمد";
  int _selectedIndex = 0;
  Color backgroundColor = Colors.white.withOpacity(0.92);
  bool hasNewNotifications = false;

  Future<void> logoutUser() async {
    // Add backend logout logic here
    // For example:
    // await authProvider.logout();
    // or
    // await apiService.logout();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    switch (index) {
      case 0:
        // Get.to(() => SearchScreen())?.then((_) {
        //   setState(() {
        //     _selectedIndex = 0; // Set back to the home index
        //   });
        // });
        break;
      case 1:
        Get.to(() => TherapistClients())?.then((_) {
          setState(() {
            _selectedIndex = 0; // Set back to the home index
          });
        });
        break;
      case 2:
        Get.to(() => WriteNotes())?.then((_) {
          setState(() {
            _selectedIndex = 0; // Set back to the home index
          });
        });
        break;
      case 3:
        Get.to(() => TherapistChats())?.then((_) {
          setState(() {
            _selectedIndex = 0; // Set back to the home index
          });
        });
        break;
      case 4:
      // Navigate to Therapist Sessions screen
        Get.to(() => Therapistssessions())?.then((_) {
          setState(() {
            _selectedIndex = 0; // Set back to the home index
          });
        });
        break;

    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xffF4D7F4),
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),)),

        title: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Open the drawer when tapped
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: const Image(
                      image: AssetImage('lib/images/download (1).jpg'),
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Text(
                  " مرحبا، دكتور $username",
                  style: GoogleFonts.almarai(
                    color: Color(0xff5A3D5C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(TherapistNotifs());
                },
                icon: Icon(
                  Icons.notifications_rounded,
                  size: 35,
                  color: hasNewNotifications ? Colors.purple : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 50),
          children: <Widget>[
            ListTile(
              title: Text('الصفحة الشخصية',
                style: GoogleFonts.almarai(
                    fontSize: 20, color: Color(0xff5A3D5C)),),
              onTap: () {
                Get.to(TherapistProfile());
              },
            ),
            ListTile(
              title: Text('الملاحظات',
                style: GoogleFonts.almarai(
                    fontSize: 20, color: Color(0xff5A3D5C)),),
              onTap: () {
                Get.to(GeneralNotes());
              },
            ),
            ListTile(
              title: Text('تسجيل خروج',
                  style: GoogleFonts.almarai(
                      fontSize: 20, color: Color(0xff5A3D5C))),
              onTap: () async {
                // Show the confirmation dialog
                bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('تأكيد تسجيل الخروج',
                          style: GoogleFonts.almarai()),
                      content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟',
                          style: GoogleFonts.almarai(fontSize: 18)),
                      actions: [
                        TextButton(
                          child: Text('إلغاء',
                              style: GoogleFonts.almarai(fontSize: 15)),
                          onPressed: () {
                            // Close the dialog without logging out
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('نعم',
                              style: GoogleFonts.almarai(fontSize: 15)),
                          onPressed: () {
                            // Close the dialog and log the user out
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                // If the user confirmed, proceed with the logout process
                if (confirmed ?? false) {
                  // Perform the backend work for logging out the user
                  await logoutUser();

                  // Navigate to the login screen or perform any other necessary actions
                  // For example:
                  // Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4D7F4), // Background color
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(50),
                bottom: Radius.circular(50)), // Radius for the top corners
            border: Border.all(
              color: Colors.purple,
                width: 1
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10), // Add vertical padding
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'الرئيسية', 0),
                  _buildNavItem(Icons.people_rounded, 'العملاء', 1),
                  _buildNavItem(Icons.edit_note_outlined, 'الملاحظات', 2),
                  _buildNavItem(Icons.chat, 'الدردشة', 3),
                  _buildNavItem(Icons.calendar_month, 'المواعيد', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.purple : Colors.grey.shade600,
            size: 35, // Adjust icon size
          ),
          Text(
            label,
            style: GoogleFonts.almarai(
              textStyle: TextStyle(
                color: isSelected ? Colors.purple : Colors.grey.shade600,
                fontSize: 16, // Adjust font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/ChatsScreen.dart';
import 'package:lati_project/features/auth/screens/SessionsScreen.dart';
import 'package:lati_project/features/auth/screens/NotificationsScreen.dart';

import 'ClientProfile.dart';
import 'FavoritesScreen.dart';
import 'WriteJournal.dart';
import 'SearchScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "محمد";
  Color backgroundColor = Colors.white.withOpacity(0.92);
  int _selectedIndex = 0; // Track the selected index
  bool hasNewNotifications = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    switch (index) {
      case 0:
        //Get.to(() => HomePage()); // Replace with actual HomeScreen
        break;
      case 1:
        Get.to(() => SearchScreen())?.then((_) {
          // Reset the selected index when returning from SearchScreen
          setState(() {
            _selectedIndex = 0; // Set back to the home index
          });
        });
        break;
      case 2:
        Get.to(() => FavoritesScreen())?.then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });

        break;
      case 3:
        Get.to(() => ChatsScreen())?.then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });

        break;
      case 4:
        Get.to(() => SessionsScreen())?.then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xffF4D7F4),
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ClientProfile());
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: const Image(
                      image: AssetImage('lib/images/download (1).jpg'),
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 130),
                child: Text(
                  " أهلا بك، $username",
                  style: GoogleFonts.almarai(
                    color: Color(0xff5A3D5C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(NotificationsScreen());
                },
                icon: Icon(
                  Icons.notifications_rounded,
                  size: 35,
                    color: hasNewNotifications ? Colors.purple : Colors.black38,)
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(WriteJournal());
                    print("Container tapped!");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF6F3B2),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 20),
                          child: Center(
                            child: Text(
                              "كيف تشعر اليوم؟",
                              style: GoogleFonts.almarai(
                                color: Color(0xff735575),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        MoodRow(),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10, right: 40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الجلسات القادمة",
                    style: GoogleFonts.almarai(
                      color: Color(0xff5A3D5C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              HorizontalCardList(),
            ],
          ),
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
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10), // Add vertical padding
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.search, 'البحث', 1),
                  _buildNavItem(Icons.favorite, 'المفضلة', 2),
                  _buildNavItem(Icons.home, 'الرئيسية', 0),
                  _buildNavItem(Icons.chat, 'الدردشة', 3),
                  _buildNavItem(Icons.group, 'المواعيد', 4),
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
            color: isSelected ? Colors.purple : Colors.grey.shade500,
            size: 35, // Adjust icon size
          ),
          Text(
            label,
            style: GoogleFonts.almarai( textStyle: TextStyle(
              color: isSelected ? Colors.purple : Colors.grey,
              fontSize: 16, // Adjust font size
            ),
            )
          ),
        ],
      ),
    );
  }

}

class MoodRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MoodIconButton(icon: Icons.insert_emoticon, label: 'سعيد', color: Color(0xFF4CBD57)),
        MoodIconButton(icon: Icons.sentiment_satisfied, label: 'جيد', color: Color(0xFFFFB300)),
        MoodIconButton(icon: Icons.sentiment_neutral, label: 'معتدل', color: Color(0xFFF36A92)),
        MoodIconButton(icon: Icons.sentiment_dissatisfied, label: 'غاضب', color: Color(0xFFFF0000)),
        MoodIconButton(icon: Icons.sentiment_very_dissatisfied, label: 'حزين', color: Color(0xFF4278A4)),

      ],
    );
  }
}

class MoodIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  MoodIconButton({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, size: 45, color: color),
            onPressed: () {
              Get.to(WriteJournal());
              print('$label button pressed');
            },
          ),
          Text(label, style: GoogleFonts.almarai(textStyle: TextStyle(fontSize: 16, color: color))),
        ],
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Number of cards you want
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SessionCard(),
            );
          },
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      color: Color(0xffF2EFF3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: const Image(
                    image: AssetImage('lib/images/download (1).jpg'),
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. سناء المنقوش',
                      style: GoogleFonts.almarai(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'جلسة استرخاء',
                        style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xff584153).withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: SizedBox(
                      height: 40,
                      width: 95,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('التفاصيل', style: GoogleFonts.almarai(textStyle: TextStyle(fontSize: 12))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  '2024/10/6',
                  style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.black54, fontSize: 14)),
                ),
                SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  '6:30 مساءً',
                  style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.black54, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
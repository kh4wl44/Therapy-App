import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "محمد";

  Color backgroundColor = Colors.white.withOpacity(0.92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Added scrollable container
        child: Container(
          color: backgroundColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align column content to the start
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, right: 50),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle tap
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: const Image(
                          image: AssetImage('lib/images/download (1).jpg'),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "أهلا بك، $username",
                        style: GoogleFonts.almarai(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                child: Center(
                  child: Text(
                    "كيف تشعر اليوم؟",
                    style: GoogleFonts.almarai(
                      color: Colors.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              MoodRow(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 20, right: 40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الجلسات القادمة",
                    style: GoogleFonts.almarai(
                      color: Colors.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              HorizontalCardList(), // Removed unnecessary wrapping Row
            ],
          ),
        ),
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
        MoodIconButton(icon: Icons.insert_emoticon, label: 'سعيد', color: Color(0xFFFBA17E)),
        MoodIconButton(icon: Icons.sentiment_satisfied, label: 'جيد', color: Color(0xFFFF575A)),
        MoodIconButton(icon: Icons.sentiment_neutral, label: 'معتدل', color: Color(0xFFF36A92)),
        MoodIconButton(icon: Icons.sentiment_dissatisfied, label: 'غاضب', color: Color(0xFF7D5BA7)),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: color),
          onPressed: () {
            // Handle button press
            print('$label button pressed');
          },
        ),
        Text(label, style: TextStyle(fontSize: 16, color: color)),
      ],
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120, // Ensure a fixed height for the card list
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemCount: 10, // Number of cards you want
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0), // Spacing between cards
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
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
                  children: [
                    Text(
                      'د. سناء المنقوش',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColorPurple,
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'جلسة استرخاء',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryColorBlack.withOpacity(0.60),
                        ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: SizedBox(
                      height: 30,
                      width:  80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.purple, // foreground
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),

                          ),
                        ),
                        onPressed: () {},
                        child: Text('التفاصيل', style: TextStyle(fontSize: 8)),


                      ),
                    ),
                  ),
                ),

              ],
            ),
            /*SizedBox(height: 10), // Add space before the Divider
            Divider(
              color: AppColors.primaryColorPurple,
              thickness: 1,
            ),*/
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  '2024/10/6',
                  style: TextStyle(color: Colors.black54, fontSize: 10),
                ),
                SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  '6:30 مساءً',
                  style: TextStyle(color: Colors.black54, fontSize: 10),
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

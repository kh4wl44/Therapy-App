import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lati_project/features/auth/screens/Register/prefferedLanguage.dart';
import 'package:lati_project/features/auth/screens/Register/ClientTypes.dart';

class ChooseTopicsToShare extends StatelessWidget {
  
   final RegistrationController controller = Get.find<RegistrationController>();

    ChooseTopicsToShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF4A1BE),
        title: Text(
          "4/3",
          style: GoogleFonts.almarai(
            textStyle: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffF4A1BE),
              Color(0xffBF75D4),
              Color(0xff9064F4),
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "اختر المواضيع التي تود مشاركتها مع المعالج",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.almarai(
                      textStyle: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                  ),
                  children: [
                    CustomButton('اضطرابات القلق', 'anxiety'),
                    CustomButton('مشاكل الغضب', 'anger'),
                    CustomButton('اضطراب ما بعد الصدمة', 'post-traumatic stress disorder'),
                    CustomButton('الإكتئاب', 'depression'),
                    CustomButton('التنمر', 'bullying'),
                    CustomButton('التوحد', 'autism'),
                    CustomButton('ضغط العمل', 'work stress'),
                    CustomButton('فقد شخص عزيز', 'loss of loved one'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 180.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(()=>PrefferedLanguage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff561789),
                    minimumSize: Size(double.minPositive, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'التالي',
                    style: GoogleFonts.almarai(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String title;
  final String topic;

  CustomButton(this.title,this.topic);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.find<RegistrationController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (controller.topics.contains(widget.topic)) {
            controller.topics.remove(widget.topic);
          } else {
            controller.topics.add(widget.topic);
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isPressed ? Colors.purple : Colors.white,
          foregroundColor: isPressed ? Colors.white : Colors.deepPurple,
        ),
        child: Text(
          widget.title,
          style: GoogleFonts.almarai(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

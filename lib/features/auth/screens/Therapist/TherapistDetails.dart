import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lati_project/api/api_service.dart';

import 'TherapistHome.dart';

class TherapistDetails extends StatefulWidget {
  late final String name;
  late final Details details;
  TherapistDetails({Key? key, required this.name, required this.details}) : super(key: key);

  @override
  State<TherapistDetails> createState() => _TherapistDetailsState();
}

class _TherapistDetailsState extends State<TherapistDetails> {
  final TextEditingController qualificationsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController clientTypesController = TextEditingController();
  final TextEditingController issuesTreatedController = TextEditingController();
  final TextEditingController treatmentApproachesController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  XFile? certificateImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        certificateImage = image;
      });
    }
  }

  void _submitDetails() {
    if (_areFieldsEmpty()) {
      return; // Stop submission if any field is empty
    }

    // Handle form submission logic here
    print("المؤهلات: ${qualificationsController.text}");
    print("الخبرة: ${experienceController.text}");
    print("التخصص: ${specialtyController.text}");
    print("أنواع العملاء: ${clientTypesController.text}");
    print("المشكلات التي تم علاجها: ${issuesTreatedController.text}");
    print("نهج العلاج: ${treatmentApproachesController.text}");
    print("التكلفة: ${costController.text}");
    print("التوفر: ${availabilityController.text}");
    print("مسار صورة الشهادة: ${certificateImage?.path}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TherapistHome()), // Replace with your actual homepage widget
    );

    _clearFields();
  }

  bool _areFieldsEmpty() {
    if (qualificationsController.text.isEmpty) {
      _showError("يرجى ملء المؤهلات");
      return true;
    }
    if (experienceController.text.isEmpty) {
      _showError("يرجى ملء الخبرة");
      return true;
    }
    if (specialtyController.text.isEmpty) {
      _showError("يرجى ملء التخصص");
      return true;
    }
    if (clientTypesController.text.isEmpty) {
      _showError("يرجى ملء أنواع العملاء");
      return true;
    }
    if (issuesTreatedController.text.isEmpty) {
      _showError("يرجى ملء المشكلات التي تم علاجها");
      return true;
    }
    if (treatmentApproachesController.text.isEmpty) {
      _showError("يرجى ملء نهج العلاج");
      return true;
    }
    if (costController.text.isEmpty) {
      _showError("يرجى ملء تكلفة الجلسة");
      return true;
    }
    if (availabilityController.text.isEmpty) {
      _showError("يرجى ملء التوفر");
      return true;
    }
    if (certificateImage == null) {
      _showError("يرجى تحميل شهادتك");
      return true;
    }
    return false;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.almarai()), backgroundColor: Colors.red),
    );
  }


  void _clearFields() {
    qualificationsController.clear();
    experienceController.clear();
    specialtyController.clear();
    clientTypesController.clear();
    issuesTreatedController.clear();
    treatmentApproachesController.clear();
    costController.clear();
    availabilityController.clear();
    setState(() {
      certificateImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل المعالج", style: GoogleFonts.almarai(color: Colors.white)),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledTextField("المؤهلات", qualificationsController),
              _buildLabeledTextField("الخبرة", experienceController),
              _buildLabeledTextField("التخصص", specialtyController),
              _buildLabeledTextField("أنواع العملاء", clientTypesController),
              _buildLabeledTextField("المشكلات التي تم علاجها", issuesTreatedController),
              _buildLabeledTextField("نهج العلاج", treatmentApproachesController),
              _buildLabeledTextField("تكلفة الجلسة", costController),
              _buildLabeledTextField("التوفر (مثال: يوم في الأسبوع: 1، البداية: 09:00 صباحاً، النهاية: 17:00 مساءً)", availabilityController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("تحميل صورة للشهادة", style: GoogleFonts.almarai(fontSize: 16)),
                  ),
                  if (certificateImage != null)
                    Text("تم تحميل الشهادة: ${certificateImage!.name}", style: GoogleFonts.almarai()),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("التالي", style: GoogleFonts.almarai(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.almarai(fontSize: 17, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            style: GoogleFonts.almarai(fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white54,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
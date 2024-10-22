import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lati_project/api/api_service.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  final MoodIcon? initialMood;

  JournalScreen({this.initialMood});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  List<JournalEntry> journals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    setState(() => isLoading = true);
    try {
      final result = await _apiService.getJournalEntries();
      if (result['success']) {
        setState(() {
          journals = result['entries'];
          isLoading = false;
        });
      } else {
        Get.snackbar('Error', 'Failed to load journals: ${result['message']}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اليوميات", style: GoogleFonts.almarai()),
        backgroundColor: Color(0xffF4D7F4),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : journals.isEmpty
              ? Center(
                  child: Text(
                    "لا توجد يوميات بعد",
                    style: GoogleFonts.almarai(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: journals.length,
                  itemBuilder: (context, index) {
                    final journal = journals[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        leading: Icon(_getMoodIcon(journal.moodIcon)),
                        title: Text(journal.title, style: GoogleFonts.almarai()),
                        subtitle: Text(
                          '${journal.date} ${journal.hour}',
                          style: GoogleFonts.almarai(),
                        ),
                        onTap: () => _showJournalDetails(journal),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddJournalDialog(),
        child: Icon(Icons.add),
        backgroundColor: Color(0xffF4D7F4),
      ),
    );
  }

  void _showJournalDetails(JournalEntry journal) {
    Get.dialog(
      AlertDialog(
        title: Text(journal.title, style: GoogleFonts.almarai()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('المزاج: ${_getMoodText(journal.moodIcon)}', style: GoogleFonts.almarai()),
              Text('المشاعر: ${journal.emotions.join(", ")}', style: GoogleFonts.almarai()),
              SizedBox(height: 10),
              Text(journal.content, style: GoogleFonts.almarai()),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('إغلاق', style: GoogleFonts.almarai()),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void _showAddJournalDialog() {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    MoodIcon _selectedMood = MoodIcon.NEUTRAL;
    List<String> _selectedEmotions = [];

    Get.dialog(
      AlertDialog(
        title: Text('إضافة يومية جديدة', style: GoogleFonts.almarai()),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMoodSelector((mood) => _selectedMood = mood),
                SizedBox(height: 10),
                _buildEmotionChips((emotions) => _selectedEmotions = emotions),
                SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'العنوان'),
                  validator: (value) => value!.isEmpty ? 'الرجاء إدخال عنوان' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'المحتوى'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'الرجاء إدخال المحتوى' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('إلغاء', style: GoogleFonts.almarai()),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('حفظ', style: GoogleFonts.almarai()),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final now = DateTime.now();
                final journalEntry = JournalEntry(
                  moodIcon: _selectedMood,
                  date: DateFormat('yyyy-MM-dd').format(now),
                  hour: DateFormat('HH:mm').format(now),
                  emotions: _selectedEmotions,
                  title: _titleController.text,
                  content: _contentController.text,
                );

                final result = await _apiService.addJournalEntry(journalEntry);

                if (result['success']) {
                  Get.back();
                  Get.snackbar('نجاح', 'تمت إضافة اليومية بنجاح');
                  _loadJournals();
                } else {
                  Get.snackbar('خطأ', 'فشل في إضافة اليومية: ${result['message']}');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector(Function(MoodIcon) onMoodSelected, {MoodIcon? initialMood}) {
    return Wrap(
      spacing: 10,
      children: MoodIcon.values.map((mood) {
        bool isSelected = mood == initialMood;
        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: Column(
            children: [
              Icon(_getMoodIcon(mood), size: 30, color: isSelected ? Colors.blue : null),
              Text(_getMoodText(mood), style: GoogleFonts.almarai(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmotionChips(Function(List<String>) onEmotionsSelected) {
    List<String> emotions = ['سعيد', 'حزين', 'غاضب', 'قلق', 'متحمس', 'خائف', 'محبط'];
    List<String> selectedEmotions = [];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Wrap(
          spacing: 8,
          children: emotions.map((emotion) {
            return FilterChip(
              label: Text(emotion, style: GoogleFonts.almarai(fontSize: 12)),
              selected: selectedEmotions.contains(emotion),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedEmotions.add(emotion);
                  } else {
                    selectedEmotions.remove(emotion);
                  }
                });
                onEmotionsSelected(selectedEmotions);
              },
            );
          }).toList(),
        );
      },
    );
  }

  IconData _getMoodIcon(MoodIcon mood) {
    switch (mood) {
      case MoodIcon.HAPPY: return Icons.sentiment_very_satisfied;
      case MoodIcon.SAD: return Icons.sentiment_very_dissatisfied;
      case MoodIcon.ANGRY: return Icons.mood_bad;
      case MoodIcon.NEUTRAL: return Icons.sentiment_neutral;
      case MoodIcon.ANXIOUS: return Icons.sentiment_dissatisfied;
    }
  }

  String _getMoodText(MoodIcon mood) {
    switch (mood) {
      case MoodIcon.HAPPY: return 'سعيد';
      case MoodIcon.SAD: return 'حزين';
      case MoodIcon.ANGRY: return 'غاضب';
      case MoodIcon.NEUTRAL: return 'محايد';
      case MoodIcon.ANXIOUS: return 'قلق';
    }
  }
}

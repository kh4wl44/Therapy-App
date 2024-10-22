import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class Therapistssessions extends StatefulWidget {
  @override
  _Therapistssessions createState() => _Therapistssessions();
}

class ApiService {
  final String baseUrl = '';

  Future<void> addSession(String date, String details) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'date': date, 'details': details}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create session');
    }
  }

  Future<List<dynamic>> getSessions() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load sessions');
    }
  }
}

class _Therapistssessions extends State<Therapistssessions> {
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController patientController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _sessions = {};
  Set<DateTime> _closedDays = {}; // Track closed days

  @override
  void initState() {
    super.initState();
    _loadSessions(); // Load sessions when the app starts
  }

  Future<void> _loadSessions() async {
    try {
      final sessionsList = await ApiService().getSessions();
      setState(() {
        for (var session in sessionsList) {
          DateTime sessionDate = DateTime.parse(session['date']);
          String details = session['details'];
          if (_sessions[sessionDate] == null) {
            _sessions[sessionDate] = [];
          }
          _sessions[sessionDate]!.add(details);
        }
      });
    } catch (e) {
      print('Error loading sessions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('سيتم تحميل الجلسات إن وجد.',
          style: GoogleFonts.almarai(),)),
      );
    }
  }

  @override
  void dispose() {
    sessionController.dispose();
    patientController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSessions = _sessions[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الجلسات',
          style: GoogleFonts.almarai(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.almarai(fontSize: 20),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.almarai(),
              weekendStyle: GoogleFonts.almarai(),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: selectedSessions.isEmpty
                ? Center(
              child: Text(
                _closedDays.contains(_selectedDay)
                    ? 'تم إغلاق الحجوزات لهذا اليوم.'
                    : 'لا توجد جلسات لهذا اليوم.',
                style: GoogleFonts.almarai(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: selectedSessions.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xff72EF7E),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      'جلسة مع ${selectedSessions[index]}',
                      style: GoogleFonts.almarai(fontSize: 18),
                    ),
                    subtitle: Text(
                      'تفاصيل الجلسة مع ${selectedSessions[index]}',
                      style: GoogleFonts.almarai(
                        textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                      ),
                    ),
                    onTap: () {
                      // Handle tap on the session item
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _closedDays.contains(_selectedDay) ? null : _showAddSessionDialog,
            child: Text(
              'حجز جلسة جديدة',
              style: GoogleFonts.almarai(color: Colors.white, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _toggleAvailability();
              },
              child: Text(
                _closedDays.contains(_selectedDay) ? 'فتح الحجوزات لهذا اليوم' : 'إغلاق الحجوزات لهذا اليوم',
                style: GoogleFonts.almarai(color: Colors.white, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _closedDays.contains(_selectedDay) ? Colors.green : Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability() {
    setState(() {
      if (_closedDays.contains(_selectedDay)) {
        _closedDays.remove(_selectedDay); // Open the day
      } else {
        _closedDays.add(_selectedDay); // Close the day
      }
    });
  }

  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('حجز جلسة جديدة', style: GoogleFonts.almarai()),
          content: Container(
            width: 400,
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: GoogleFonts.almarai(),
                  controller: sessionController,
                  decoration: InputDecoration(hintText: 'أدخل اسم الجلسة', labelStyle: TextStyle(color: Colors.grey.shade200)),
                ),
                TextField(
                  style: GoogleFonts.almarai(),
                  controller: patientController,
                  decoration: InputDecoration(hintText: 'أدخل اسم المريض', labelStyle: TextStyle(color: Colors.grey.shade200)),
                ),
                TextField(
                  style: GoogleFonts.almarai(),
                  controller: timeController,
                  decoration: InputDecoration(hintText: 'أدخل وقت الجلسة (مثل: 10:30 صباحاً)', labelStyle: TextStyle(color: Colors.grey.shade200)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: GoogleFonts.almarai()),
            ),
            TextButton(
              onPressed: () async {
                if (sessionController.text.isNotEmpty && patientController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  // Save session through API
                  try {
                    await ApiService().addSession(
                        _selectedDay.toIso8601String(),
                        '${patientController.text} - ${sessionController.text} في ${timeController.text}'
                    );

                    setState(() {
                      if (_sessions[_selectedDay] == null) {
                        _sessions[_selectedDay] = [];
                      }
                      _sessions[_selectedDay]!.add(
                        '${patientController.text} - ${sessionController.text} في ${timeController.text}',
                      );
                    });
                    sessionController.clear();
                    patientController.clear();
                    timeController.clear();
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Handle error
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل في حجز الجلسة.')),
                    );
                  }
                }
              },
              child: Text('حفظ', style: GoogleFonts.almarai()),
            ),
          ],
        );
      },
    );
  }
}
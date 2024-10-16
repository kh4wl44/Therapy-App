import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionsScreen extends StatefulWidget {
  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  // Initialize the calendar and sessions
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _sessions = {};
  Set<DateTime> _closedDays = {}; // Track closed days

  @override
  Widget build(BuildContext context) {
    // Get sessions for the selected day
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
          // Calendar widget
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
          SizedBox(height: 16), // Space between calendar and sessions list
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
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'جلسة مع ${selectedSessions[index]}',
                      style: GoogleFonts.almarai(fontSize: 18),
                    ),
                    subtitle: Text(
                      'تفاصيل الجلسة مع ${selectedSessions[index]}',
                      style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                    ),
                    onTap: () {
                      // Handle tap on the session item
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _closedDays.contains(_selectedDay) ? null : _showAddSessionDialog,
              child: Text(
                'حجز جلسة جديدة',
                style: GoogleFonts.almarai(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _toggleAvailability();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _closedDays.contains(_selectedDay) ? Colors.green : Colors.red, // Change color based on condition
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text(
                _closedDays.contains(_selectedDay) ? 'فتح الحجوزات لهذا اليوم' : 'إغلاق الحجوزات لهذا اليوم',
                style: GoogleFonts.almarai(color: Colors.white),
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
    final TextEditingController sessionController = TextEditingController();
    final TextEditingController patientController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('حجز جلسة جديدة', style: GoogleFonts.almarai()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField( style: GoogleFonts.almarai(),
                controller: sessionController,
                decoration: InputDecoration(hintText: 'أدخل اسم الجلسة'),
              ),
              TextField( style: GoogleFonts.almarai(),
                controller: patientController,
                decoration: InputDecoration(hintText: 'أدخل اسم المريض'),
              ),
              TextField( style: GoogleFonts.almarai(),
                controller: timeController,
                decoration: InputDecoration(hintText: 'أدخل وقت الجلسة (مثل: 10:30 AM)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: GoogleFonts.almarai()),
            ),
            TextButton(
              onPressed: () {
                if (sessionController.text.isNotEmpty &&
                    patientController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  setState(() {
                    if (_sessions[_selectedDay] == null) {
                      _sessions[_selectedDay] = [];
                    }
                    _sessions[_selectedDay]!.add(
                      '${patientController.text} - ${sessionController.text} في ${timeController.text}',
                    );
                  });
                  Navigator.of(context).pop();
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionsScreen extends StatefulWidget {
  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _appointments = {
    // Sample data for demonstration
    DateTime.now(): ['جلسة مع الطبيب 1', 'جلسة مع الطبيب 2'],
    DateTime.now().add(Duration(days: 1)): ['جلسة مع الطبيب 3'],
  };

  @override
  Widget build(BuildContext context) {
    final selectedAppointments = _appointments[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مواعيد الجلسات',
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
            child: selectedAppointments.isEmpty
                ? Center(
              child: Text(
                'لا توجد جلسات لهذا اليوم.',
                style: GoogleFonts.almarai(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: selectedAppointments.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      selectedAppointments[index],
                      style: GoogleFonts.almarai(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
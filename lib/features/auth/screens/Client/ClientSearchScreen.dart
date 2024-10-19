import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  // Filter options
  String? _selectedGender;
  String? _selectedAvailability;
  String? _selectedCost;
  String? _selectedSpecialty;

  final List<String> _genderFilters = ['ذكر', 'أنثى']; // Male, Female
  final List<String> _availabilityFilters = ['09:00 - 17:00']; // Available times
  final List<String> _costFilters = ['100']; // Cost
  final List<String> _specialtyFilters = ['قلق', 'اكتئاب']; // Anxiety, Depression

  Future<void> _performSearch() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
    });

    final query = _controller.text;
    final genderFilter = _selectedGender != null ? _selectedGender : '';
    final availabilityFilter = _selectedAvailability != null ? _selectedAvailability : '';
    final costFilter = _selectedCost != null ? _selectedCost : '';
    final specialtyFilter = _selectedSpecialty != null ? _selectedSpecialty : '';

    final response = await http.get(Uri.parse(
        'http://your-api-url/search?q=$query&gender=$genderFilter&availability=$availabilityFilter&cost=$costFilter&specialty=$specialtyFilter')); // Adjust API endpoint

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body); // Assuming the response body is a JSON array
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('فلترة النتائج', style: GoogleFonts.almarai())),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gender Filter
                DropdownButton<String>(
                  hint: Text('اختر الجنس', style: GoogleFonts.almarai()),
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: _genderFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.almarai()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Availability Filter
                DropdownButton<String>(
                  hint: Text('اختر التوفر', style: GoogleFonts.almarai()),
                  value: _selectedAvailability,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAvailability = newValue;
                    });
                  },
                  items: _availabilityFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.almarai()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Cost Filter
                DropdownButton<String>(
                  hint: Text('اختر التكلفة', style: GoogleFonts.almarai()),
                  value: _selectedCost,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCost = newValue;
                    });
                  },
                  items: _costFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.almarai()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Specialty Filter
                DropdownButton<String>(
                  hint: Text('اختر التخصص', style: GoogleFonts.almarai()),
                  value: _selectedSpecialty,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSpecialty = newValue;
                    });
                  },
                  items: _specialtyFilters.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.almarai()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('إغلاق', style: GoogleFonts.almarai()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'البحث',
          style: GoogleFonts.almarai(color: Colors.white), // Search title
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.almarai(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'ابحث هنا..',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    onSubmitted: (value) {
                      _performSearch(); // Perform search when user submits
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.purple),
                  onPressed: _showFilterDialog, // Show filter dialog
                ),
              ],
            ),
            SizedBox(height: 20), // Space between search bar and filters

            // Display selected filters

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: [
                  if (_selectedGender != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        side: BorderSide(color: Colors.green.shade400),
                        backgroundColor: Color(0xffc9ef9e),
                        deleteIconColor: Colors.red.shade300,
                        label: Text('الجنس: $_selectedGender', style: GoogleFonts.almarai(fontSize: 15)),
                        onDeleted: () {
                          setState(() {
                            _selectedGender = null; // Clear gender filter
                          });
                        },
                      ),
                    ),
                  if (_selectedAvailability != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        side: BorderSide(color: Colors.green.shade400),
                        backgroundColor: Color(0xffc9ef9e),
                        deleteIconColor: Colors.red.shade300,
                        label: Text('التوفر: $_selectedAvailability', style: GoogleFonts.almarai(fontSize: 15)),
                        onDeleted: () {
                          setState(() {
                            _selectedAvailability = null; // Clear availability filter
                          });
                        },
                      ),
                    ),
                  if (_selectedCost != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        side: BorderSide(color: Colors.green.shade400),
                        backgroundColor: Color(0xffc9ef9e),
                        deleteIconColor: Colors.red.shade300,
                        label: Text('التكلفة: $_selectedCost', style: GoogleFonts.almarai(fontSize: 15)),
                        onDeleted: () {
                          setState(() {
                            _selectedCost = null; // Clear cost filter
                          });
                        },
                      ),
                    ),
                  if (_selectedSpecialty != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Chip(
                        side: BorderSide(color: Colors.green.shade400),
                        backgroundColor: Color(0xffc9ef9e),
                        deleteIconColor: Colors.red.shade300,
                        label: Text('التخصص: $_selectedSpecialty', style: GoogleFonts.almarai(fontSize: 15)),
                        onDeleted: () {
                          setState(() {
                            _selectedSpecialty = null; // Clear specialty filter
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between filter chips and results

            // Loading indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'لا توجد نتائج.',
                    style: GoogleFonts.almarai(fontSize: 20, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(item['title'], style: GoogleFonts.almarai(fontSize: 18)), // Adjust based on your data structure
                        subtitle: Text(
                          item['description'], // Adjust based on your data structure
                          style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                        onTap: () {
                          // Handle tap on search result
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
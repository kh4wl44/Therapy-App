import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lati_project/api/api_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final ApiService _apiService = Get.find<ApiService>();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
    });

    try {
      final filters = SearchFilters(
        name: _controller.text,
        // Add other filters as needed
      );

      final results = await _apiService.searchTherapists(filters);

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching therapists: $e');
      setState(() {
        _isLoading = false;
      });
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching therapists')),
      );
    }
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
            TextField(
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
            SizedBox(height: 20), // Space between search bar and results

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
                     final therapist = _searchResults[index];
                     return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(therapist.userId, style: GoogleFonts.almarai(fontSize: 18)),
                        subtitle: Text(
                          therapist.specialty,
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
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

  Future<void> _performSearch() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
    });

    final query = _controller.text;
    final response = await http.get(Uri.parse('http://your-api-url/search?q=$query')); // Replace with your actual Ktor endpoint

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
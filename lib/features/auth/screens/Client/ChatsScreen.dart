import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../api/api_service.dart';
import 'ClientSearchScreen.dart';
// Import GetX for navigation

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  List<Conversation> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Conversation> fetchedConversations = await _apiService.getConversations();
      setState(() {
        conversations = fetchedConversations;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading conversations: $e');
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Failed to load conversations');
    }
  }

  Future<void> _startNewConversation(String therapistId) async {
    try {
      String? conversationId = await _apiService.startConversation(therapistId);
      if (conversationId != null) {
        _loadConversations(); // Refresh the conversations list
      }
    } catch (e) {
      print('Error starting conversation: $e');
      Get.snackbar('Error', 'Failed to start conversation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الدردشات',
          style: GoogleFonts.almarai(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : conversations.isEmpty
              ? _buildEmptyState()
              : _buildConversationsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => SearchScreen());
          if (result != null && result is String) {
            _startNewConversation(result);
          }
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'لا توجد دردشات بعد.',
            style: GoogleFonts.almarai(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'اضغط على زر "+" لبدء دردشة جديدة.',
            style: GoogleFonts.almarai(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList() {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(conversation.therapistId.substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white)),
            ),
            title: Text(
              'محادثة مع ${conversation.therapistId}',
              style: GoogleFonts.almarai(fontSize: 18),
            ),
            subtitle: Text(
              conversation.messages.isNotEmpty
                  ? conversation.messages.last.content
                  : 'لا توجد رسائل بعد',
              style: GoogleFonts.almarai(textStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            onTap: () {
              // Navigate to chat detail screen
              // Get.to(() => ChatDetailScreen(conversation: conversation));
            },


          ),
        );
      },


    );
  }

}

class Conversation {
  final String therapistId;
  final List<Message> messages;

  Conversation({required this.therapistId, required this.messages});
}

class Message {
  final String content;

  Message({required this.content});
}

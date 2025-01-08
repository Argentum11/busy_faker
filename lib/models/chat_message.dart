class ChatMessage {
  final String request;
  final String response;

  ChatMessage({
    required this.request,
    required this.response,
  });
}

class ChatRecord {
  List<ChatMessage> messages = [];
  final String caller;
  final String topic;

  ChatRecord({required this.caller, required this.topic});
}
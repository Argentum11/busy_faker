import 'package:hive/hive.dart';

part "chat_message.g.dart";

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String request;

  @HiveField(1)
  final String response;

  ChatMessage({
    required this.request,
    required this.response,
  });
}

@HiveType(typeId: 1)
class ChatRecord {
  @HiveField(0)
  List<ChatMessage> messages = [];

  @HiveField(1)
  final String caller;

  @HiveField(2)
  final String topic;

  ChatRecord({required this.caller, required this.topic});
}

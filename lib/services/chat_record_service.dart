import 'package:busy_faker/models/chat_message.dart';

class ChatRecordService {
  static final ChatRecordService _instance = ChatRecordService._internal();
  factory ChatRecordService() => _instance;

  ChatRecordService._internal() {
    ChatRecord c1 = ChatRecord(caller: "john", topic: "work");
    c1.messages.add(ChatMessage(request: "hello", response: "hello, how can i help you"));
    _records.add(c1);
  }

  final List<ChatRecord> _records = [];

  List<ChatRecord> get records => List.unmodifiable(_records);

  void addRecord(ChatRecord record) {
    _records.add(record);
  }

  void clearRecords() {
    _records.clear();
  }
}

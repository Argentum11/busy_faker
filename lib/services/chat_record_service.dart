import 'package:busy_faker/models/chat_message.dart';
import 'package:hive/hive.dart';

class ChatRecordService {
  static final ChatRecordService _instance = ChatRecordService._internal();
  factory ChatRecordService() => _instance;

  ChatRecordService._internal();

  Future<void> saveRecord(ChatRecord record) async {
    final box = await Hive.openBox<ChatRecord>('chatRecords');
    await box.add(record);
  }

  Future<List<ChatRecord>> getRecords() async {
    final box = await Hive.openBox<ChatRecord>('chatRecords');
    return box.values.toList();
  }

  void clearRecords() async {
    final box = await Hive.openBox<ChatRecord>('chatRecords');
    await box.clear();
  }
}

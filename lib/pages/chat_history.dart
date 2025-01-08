import 'package:busy_faker/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:busy_faker/services/chat.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final records = ChatService().records;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return ChatRecordBlock(
              record: record,
            );
          },
        ),
      ),
    );
  }
}

class ChatRecordBlock extends StatelessWidget {
  final ChatRecord record;
  const ChatRecordBlock({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${record.caller} - ${record.topic}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: record.messages.length,
            itemBuilder: (context, index) {
              final message = record.messages[index];
              return ChatMessageBlock(
                message: message,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessageBlock extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageBlock({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Text(message.request),
          ),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Text(message.response),
            ),
          ),
        ],
      ),
    );
  }
}
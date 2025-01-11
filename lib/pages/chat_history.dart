import 'package:flutter/material.dart';
import 'package:busy_faker/services/chat_record_service.dart';
import 'package:busy_faker/models/chat_message.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatRecord> _filterRecords(List<ChatRecord> records) {
    if (_searchQuery.isEmpty) return records;

    return records.where((record) {
      // Search in caller and topic
      if (record.caller.toLowerCase().contains(_searchQuery.toLowerCase()) || record.topic.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return true;
      }

      // Search in messages
      return record.messages.any((message) =>
          message.request.toLowerCase().contains(_searchQuery.toLowerCase()) || message.response.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final records = ChatRecordService().records;
    final filteredRecords = _filterRecords(records);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search in chat history...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            if (filteredRecords.isEmpty && _searchQuery.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No results found'),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = filteredRecords[index];
                  return ChatRecordBlock(
                    record: record,
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

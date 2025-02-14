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
  late Future<List<ChatRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = ChatRecordService().getRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatRecord> _filterRecords(List<ChatRecord> records) {
    if (_searchQuery.isEmpty) return records;

    // Search in caller and topic
    return records.where((record) {
      if (record.caller.toLowerCase().contains(_searchQuery.toLowerCase()) || record.topic.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return true;
      }

      // Search in messages
      return record.messages.any((message) =>
          message.request.toLowerCase().contains(_searchQuery.toLowerCase()) || message.response.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('確認清除'),
          content: const Text('確定要清除所有聊天記錄嗎？此操作無法復原。'),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('確定清除'),
              onPressed: () async {
                // Capture the scaffold context before async operation
                final scaffoldContext = ScaffoldMessenger.of(context);

                // Close the dialog first
                Navigator.of(dialogContext).pop();

                // Clear records and handle the result
                try {
                  await ChatRecordService().clearRecords();
                  if (mounted) {
                    setState(() {
                      _recordsFuture = ChatRecordService().getRecords();
                    });
                    scaffoldContext.showSnackBar(
                      const SnackBar(content: Text('已清除所有聊天記錄')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    scaffoldContext.showSnackBar(
                      SnackBar(content: Text('清除記錄時發生錯誤: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showClearConfirmationDialog,
        tooltip: '清除所有記錄',
        child: const Icon(Icons.delete_forever),
      ),
      appBar: AppBar(
        title: const Text('聊天記錄'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: '搜尋聊天記錄...',
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
          child: FutureBuilder<List<ChatRecord>>(
              future: _recordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('尚無聊天記錄'),
                  );
                }

                final filteredRecords = _filterRecords(snapshot.data!);

                if (filteredRecords.isEmpty && _searchQuery.isNotEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('未找到符合搜尋字詞的記錄'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record = filteredRecords[index];
                    return ChatRecordBlock(
                      record: record,
                    );
                  },
                );
              })),
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

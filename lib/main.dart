import 'package:busy_faker/pages/caller_selection.dart';
import 'package:flutter/material.dart';
import 'package:busy_faker/pages/chat_history.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:busy_faker/models/chat_message.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatRecordAdapter());

  runApp(const BusyFaker());
}

class BusyFaker extends StatefulWidget {
  const BusyFaker({super.key});

  @override
  BusyFakerState createState() => BusyFakerState();
}

class BusyFakerState extends State<BusyFaker> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const CallerSelectionPage(),
    const ChatHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busy Faker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: '通話',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '聊天記錄',
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

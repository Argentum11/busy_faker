import 'package:busy_faker/pages/chat_history.dart';
import 'package:flutter/material.dart';
import 'pages/timer_selection.dart';

void main() {
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
    const TimerSelectionPage(),
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
              icon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Chat history',
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

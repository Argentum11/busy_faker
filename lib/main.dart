import 'package:flutter/material.dart';
import 'pages/timer_selection_page.dart';

void main() {
  runApp(const BusyFaker());
}

class BusyFaker extends StatelessWidget {
  const BusyFaker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busy Faker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerSelectionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

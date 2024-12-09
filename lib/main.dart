import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const BusyFaker());
}

class BusyFaker extends StatelessWidget {
  const BusyFaker({super.key});

  // application root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerSelectionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerSelectionPage extends StatefulWidget {
  const TimerSelectionPage({super.key});

  @override
  _TimerSelectionPageState createState() => _TimerSelectionPageState();
}

class _TimerSelectionPageState extends State<TimerSelectionPage> {
  int _minutes = 0;
  int _seconds = 0;

  void _startTimer() async {
    final duration = Duration(minutes: _minutes, seconds: _seconds);
    await Future.delayed(duration);

    // prevent the widget is still in the widget tree (not navigated to a different screen)
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Times up"),
        content: Text(
            "Duration: ${duration.inMinutes} min ${duration.inSeconds % 60} sec"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Timer Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text("Minutes", style: TextStyle(fontSize: 16)),
                    NumberPicker(
                      value: _minutes,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => _minutes = value),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    const Text("Seconds", style: TextStyle(fontSize: 16)),
                    NumberPicker(
                      value: _seconds,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => _seconds = value),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startTimer,
              child: const Text("Start Timer"),
            ),
          ],
        ),
      ),
    );
  }
}

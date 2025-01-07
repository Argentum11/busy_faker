import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'caller_selection.dart';

class TimerSelectionPage extends StatefulWidget {
  const TimerSelectionPage({super.key});

  @override
  TimerSelectionPageState createState() => TimerSelectionPageState();
}

class TimerSelectionPageState extends State<TimerSelectionPage> {
  int _minutes = 0;
  int _seconds = 0;

  void _navigateToCharacterSelectionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallerSelectionPage(
          minutes: _minutes,
          seconds: _seconds,
        ),
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
              onPressed: _navigateToCharacterSelectionPage,
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}

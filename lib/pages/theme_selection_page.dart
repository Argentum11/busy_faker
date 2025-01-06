import 'package:flutter/material.dart';
import 'fake_phone_call.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Selection Page')),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ThemeButton(theme: 'AI conversation'),
          ThemeButton(theme: 'Theme 1'),
          ThemeButton(theme: 'Theme 2'),
          ThemeButton(theme: 'Theme 3'),
        ],
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final String theme;
  const ThemeButton({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FakePhoneCallPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 0),
        ),
        child: Text(
          theme,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

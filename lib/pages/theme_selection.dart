import 'package:flutter/material.dart';
import 'package:busy_faker/models/caller.dart';
import 'fake_phone_call.dart';

class ThemeSelectionPage extends StatelessWidget {
  final Caller caller;
  final int callDelay;
  const ThemeSelectionPage({super.key, required this.caller, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a theme')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ThemeButton(theme: 'AI conversation', caller: caller, callDelay: callDelay),
          ThemeButton(theme: 'Theme 1', caller: caller, callDelay: callDelay),
          ThemeButton(theme: 'Theme 2', caller: caller, callDelay: callDelay),
          ThemeButton(theme: 'Theme 3', caller: caller, callDelay: callDelay),
        ],
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final Caller caller;
  final String theme;
  final int callDelay;
  const ThemeButton({super.key, required this.theme, required this.caller, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FakePhoneCallPage(caller: caller, callDelay: callDelay),
            ),
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

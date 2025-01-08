import 'package:flutter/material.dart';
import 'package:busy_faker/models/caller.dart';
import 'fake_phone_call.dart';
import 'package:busy_faker/models/chat_theme.dart';

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
          ThemeButton(chatTheme: ai, caller: caller, callDelay: callDelay),
          ThemeButton(chatTheme: emergencyWork, caller: caller, callDelay: callDelay),
          ThemeButton(chatTheme: socialRelief, caller: caller, callDelay: callDelay),
          ThemeButton(chatTheme: nightCompanionship, caller: caller, callDelay: callDelay),
        ],
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final Caller caller;
  final ChatTheme chatTheme;
  final int callDelay;
  const ThemeButton({super.key, required this.chatTheme, required this.caller, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FakePhoneCallPage(
                caller: caller,
                callDelay: callDelay,
                chatTheme: chatTheme,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 0),
        ),
        child: Text(
          chatTheme.name,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

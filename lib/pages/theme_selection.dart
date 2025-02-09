import 'package:busy_faker/pages/timer_selection.dart';
import 'package:flutter/material.dart';
import 'package:busy_faker/models/caller.dart';
import 'package:busy_faker/models/chat_theme.dart';

class ThemeSelectionPage extends StatelessWidget {
  final Caller caller;

  const ThemeSelectionPage({super.key, required this.caller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '請選擇聊天主題',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ThemeButton(chatTheme: ai, caller: caller),
              ThemeButton(chatTheme: emergencyWork, caller: caller),
              ThemeButton(chatTheme: socialRelief, caller: caller),
              ThemeButton(chatTheme: nightCompanionship, caller: caller),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final Caller caller;
  final ChatTheme chatTheme;

  const ThemeButton({
    super.key,
    required this.chatTheme,
    required this.caller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimerSelectionPage(
                caller: caller,
                chatTheme: chatTheme,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  chatTheme.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatTheme.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chatTheme.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

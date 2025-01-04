import 'package:flutter/material.dart';
import 'fake_phone_call.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  void _onAiConversationPressed() {
    // 預留
  }

  void _onTheme1Pressed() {
    // 預留
  }

  void _onTheme2Pressed(BuildContext context) {
    //測試用
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FakePhoneCallPage()),
    );
  }

  void _onTheme3Pressed() {
    // 預留
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200, // button 寬
            height: 60, // button 高
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Selection Page')),
      body: Column(
        children: [
          _buildButton('AI conversation', _onAiConversationPressed),
          _buildButton('Theme 1', _onTheme1Pressed),
          _buildButton(
            //測試用
            'Theme 2',
            () => _onTheme2Pressed(context),
          ),
          _buildButton('Theme 3', _onTheme3Pressed),
        ],
      ),
    );
  }
}

import 'package:busy_faker/models/caller.dart';
import 'package:busy_faker/models/chat_theme.dart';
import 'package:busy_faker/pages/fake_phone_call.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerSelectionPage extends StatefulWidget {
  final Caller caller;
  final ChatTheme chatTheme;
  const TimerSelectionPage({super.key, required this.caller, required this.chatTheme});

  @override
  TimerSelectionPageState createState() => TimerSelectionPageState();
}

class TimerSelectionPageState extends State<TimerSelectionPage> with SingleTickerProviderStateMixin {
  int _minutes = 0;
  int _seconds = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _navigateToCharacterSelectionPage() {
    int callDelay = _minutes * 60 + _seconds;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FakePhoneCallPage(
          caller: widget.caller,
          chatTheme: widget.chatTheme,
          callDelay: callDelay,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '請選擇來電時間',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPickerColumn("分鐘", _minutes, (value) => setState(() => _minutes = value)),
                          const SizedBox(width: 32),
                          _buildPickerColumn("秒", _seconds, (value) => setState(() => _seconds = value)),
                        ],
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTapDown: (_) => _buttonController.forward(),
                        onTapUp: (_) => _buttonController.reverse(),
                        onTapCancel: () => _buttonController.reverse(),
                        child: ScaleTransition(
                          scale: _buttonScale,
                          child: ElevatedButton(
                            onPressed: _navigateToCharacterSelectionPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "確認",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerColumn(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: NumberPicker(
            value: value,
            minValue: 0,
            maxValue: 59,
            infiniteLoop: true,
            onChanged: onChanged,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
            selectedTextStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 2),
                bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:busy_faker/pages/in_call.dart';
import 'package:busy_faker/models/chat_theme.dart';
import 'package:busy_faker/models/caller.dart';

class FakePhoneCallPage extends StatefulWidget {
  final Caller caller;
  final ChatTheme chatTheme;
  final int callDelay;
  const FakePhoneCallPage({super.key, required this.caller, required this.chatTheme, required this.callDelay});

  @override
  FakePhoneCallPageState createState() => FakePhoneCallPageState();
}

class FakePhoneCallPageState extends State<FakePhoneCallPage> {
  late Timer _timer;

  final int ringDuration = 10;
  int _delayTimeRemaining = 0;
  bool _isDelaying = true;

  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: ringDuration * 1000); // Vibrate for 10 seconds
    }
  }

  void _stopVibration() {
    Vibration.cancel();
  }

  void _endCall() {
    _stopVibration();
    _timer.cancel(); // 停止計時器
    Navigator.pop(context); // 直接關閉頁面，不顯示 "Call Ended"
  }

  void _answerCall() {
    _stopVibration();
    _timer.cancel(); // 停止 10 秒計時器

    // 導向 "通話中" 頁面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => InCallPage(
                caller: widget.caller,
                chatTheme: widget.chatTheme,
              )),
    );
  }

  Future<void> _startCall() async {
    _delayTimeRemaining = widget.callDelay;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_delayTimeRemaining > 0) {
        setState(() {
          _delayTimeRemaining--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isDelaying = false;
        });
        _startVibration();
        _timer = Timer(Duration(seconds: ringDuration), _endCall);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startCall();
  }

  @override
  void dispose() {
    _stopVibration();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDelaying) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
              color: Colors.white, value: widget.callDelay == 0 ? 0 : (widget.callDelay - _delayTimeRemaining) / widget.callDelay),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '來電',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                widget.caller.imagePath,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.caller.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: _endCall, // 修改：掛斷時直接關閉頁面
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: _answerCall, // 修改：接聽時替換當前頁面
                  child: const Icon(Icons.call, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

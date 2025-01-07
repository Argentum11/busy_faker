import 'package:busy_faker/models/caller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'dart:developer' as dev;
import 'package:busy_faker/speech/tts_service.dart';
import 'package:busy_faker/models/voice_profile.dart';
import 'package:busy_faker/chat_gpt_service.dart';

class FakePhoneCallPage extends StatefulWidget {
  final Caller caller;
  const FakePhoneCallPage({super.key, required this.caller});

  @override
  FakePhoneCallPageState createState() => FakePhoneCallPageState();
}

class FakePhoneCallPageState extends State<FakePhoneCallPage> {
  late Timer _timer;

  final int ringDuration = 10;

  void _startVibration() async {
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
      MaterialPageRoute(builder: (context) => InCallPage(caller: widget.caller)),
    );
  }

  @override
  void initState() {
    super.initState();
    _startVibration();
    _timer = Timer(Duration(seconds: ringDuration), _endCall);
  }

  @override
  void dispose() {
    _stopVibration();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Incoming Call',
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

// ===============================
// "通話中" 頁面
// ===============================

class InCallPage extends StatefulWidget {
  final Caller caller;
  const InCallPage({super.key, required this.caller});

  @override
  InCallPageState createState() => InCallPageState();
}

class InCallPageState extends State<InCallPage> {
  late Timer _timer;
  int _callDuration = 0; // 通話秒數

  final TextEditingController _messageController = TextEditingController();
  String _requestMessage = '';
  String _responseMessage = '';

  // text to speech
  final TtsService _ttsService = TtsService();
  TtsState ttsState = TtsState.stopped;

  final ChatGPTService _chatGPTService = ChatGPTService();

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  void _endCall() {
    _timer.cancel();
    Navigator.pop(context); // 直接關閉頁面
  }

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _initializeTts();
  }

  @override
  void dispose() {
    _timer.cancel();
    _ttsService.stop();
    super.dispose();
  }

  void _initializeTts() async {
    await _ttsService.initialize(hybridVoice);
    _ttsService.onStateChanged = (TtsState newState) {
      setState(() {
        ttsState = newState;
      });
    };
  }

  Future<void> _saveMessage() async {
    _ttsService.stop();

    setState(() {
      _requestMessage = _messageController.text;
      _responseMessage = 'Processing...';
    });

    try {
      final response = await _chatGPTService.getChatResponse(_requestMessage);
      _responseMessage = response;
      _ttsService.speak(_responseMessage);
    } catch (e) {
      dev.log('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'In Call',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(widget.caller.imagePath),
            ),
            const SizedBox(height: 20),
            Text(
              widget.caller.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${_callDuration}s',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your message',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(onPressed: _saveMessage, child: const Text("Chat")),
            Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(_responseMessage),
              ),
            ),
          ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              onPressed: _endCall, // 掛斷時關閉頁面
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

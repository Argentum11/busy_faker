import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:developer' as dev;
import 'package:busy_faker/speech/tts_service.dart';
import 'package:busy_faker/models/voice_profile.dart';
import 'package:busy_faker/chat_gpt_service.dart';

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
      home: const ChatPage(),
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

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String _requestMessage = '';
  String _responseMessage = '';

  // text to speech
  final TtsService _ttsService = TtsService();
  TtsState ttsState = TtsState.stopped;

  final ChatGPTService _chatGPTService = ChatGPTService();

  @override
  void initState() {
    super.initState();
    _initializeTts();
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
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: [
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
          Text(_responseMessage)
        ],
      ),
    );
  }
}

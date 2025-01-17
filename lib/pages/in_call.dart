import 'package:flutter/material.dart';
import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:developer' as dev;
import 'package:busy_faker/services/text_to_speech.dart';
import 'package:busy_faker/services/ChatGPT/chat_gpt_service.dart';
import 'package:busy_faker/services/chat_record_service.dart';
import 'package:busy_faker/services/speech_to_text.dart';
import 'package:busy_faker/models/caller.dart';
import 'package:busy_faker/models/chat_theme.dart';
import 'package:busy_faker/models/chat_message.dart';

class InCallPage extends StatefulWidget {
  final Caller caller;
  final ChatTheme chatTheme;
  const InCallPage({super.key, required this.caller, required this.chatTheme});

  @override
  InCallPageState createState() => InCallPageState();
}

class InCallPageState extends State<InCallPage> {
  late Timer _timer;
  int _callDuration = 0; // 通話秒數

  String _requestMessage = '';
  String _responseMessage = '';
  String _lastWords = '';

  // text to speech
  final TextToSpeechService _textToSpeechService = TextToSpeechService();
  TextToSpeechState textToSpeechState = TextToSpeechState.stopped;

  late final ChatGPTService _chatGPTService;

  // speech to text
  //final SpeechToText _speechToText = SpeechToText();
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  bool _speechEnabled = false;

  // Add ChatRecord reference
  late ChatRecord _currentChatRecord;
  final ChatRecordService _chatRecordService = ChatRecordService();

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  void _endCall() {
    _timer.cancel();
    _chatRecordService.addRecord(_currentChatRecord);
    Navigator.pop(context); // 直接關閉頁面
  }

  @override
  void initState() {
    super.initState();
    _chatGPTService = ChatGPTService(command: widget.chatTheme.command);
    _currentChatRecord = ChatRecord(
      caller: widget.caller.name,
      topic: widget.chatTheme.name, // You can customize the topic
    );
    _startCallTimer();
    _initializeTextToSpeech();
    _initSpeechToText();
  }

  @override
  void dispose() {
    _timer.cancel();
    _textToSpeechService.stop();
    _speechToTextService.dispose();
    super.dispose();
  }

  Future<void> _initializeTextToSpeech() async {
    await _textToSpeechService.initialize(widget.caller.voiceProfile);
    _textToSpeechService.onStateChanged = (TextToSpeechState newState) {
      setState(() {
        textToSpeechState = newState;
      });
    };
  }

  Future<void> _initSpeechToText() async {
    _speechToTextService.initialize();
    _speechToTextService.onSpeechResult = _onSpeechResult;
    _speechToTextService.updateSpeechStatus = (newStatus) {
      _speechEnabled = newStatus;
    };
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _requestMessage = _lastWords;
      if (!_speechToTextService.isListening && _requestMessage.trim().isNotEmpty) {
        _saveMessage();
      }
    });
  }

  Future<void> _saveMessage() async {
    _textToSpeechService.stop();

    setState(() {
      // _requestMessage = _messageController.text;
      _responseMessage = 'Processing...';
    });

    try {
      final response = await _chatGPTService.getChatResponse(_requestMessage);
      _responseMessage = response;
      _textToSpeechService.speak(_responseMessage);
      _currentChatRecord.messages.add(
        ChatMessage(
          request: _requestMessage,
          response: _responseMessage,
        ),
      );
    } catch (e) {
      dev.log('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            const Text(
              '通話中',
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
            const SizedBox(
              height: 10,
            ),
            TextButton(onPressed: _saveMessage, child: const Text("Chat")),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _lastWords,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              _speechEnabled
                  ? _speechToTextService.isListening
                      ? ''
                      : '點擊麥克風開始說話'
                  : '麥克風尚未啟用',
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            FloatingActionButton(
              onPressed:
                  // If not yet listening for speech start, otherwise stop
                  _speechToTextService.isNotListening ? _speechToTextService.startListening : _speechToTextService.stopListening,
              tooltip: 'Listen',
              child: Icon(_speechToTextService.isNotListening ? Icons.mic_off : Icons.mic),
            ),
            SizedBox(
              height: screenHeight * 0.02,
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
            SizedBox(
              height: screenHeight * 0.1,
            )
          ],
        ),
      ),
    );
  }
}

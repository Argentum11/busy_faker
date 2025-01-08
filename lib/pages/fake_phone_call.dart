import 'package:busy_faker/models/caller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'dart:developer' as dev;
import 'package:busy_faker/speech/tts_service.dart';
import 'package:busy_faker/chat_gpt_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:busy_faker/services/chat.dart';
import 'package:busy_faker/models/chat_message.dart';

class FakePhoneCallPage extends StatefulWidget {
  final Caller caller;
  final int callDelay;
  const FakePhoneCallPage({super.key, required this.caller, required this.callDelay});

  @override
  FakePhoneCallPageState createState() => FakePhoneCallPageState();
}

class FakePhoneCallPageState extends State<FakePhoneCallPage> {
  late Timer _timer;

  final int ringDuration = 10;
  int _delayTimeRemaining = 0;
  bool _isDelaying = true;

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
  String _lastWords = '';

  // text to speech
  final TtsService _ttsService = TtsService();
  TtsState ttsState = TtsState.stopped;

  final ChatGPTService _chatGPTService = ChatGPTService();

  // speech to text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // Add ChatRecord reference
  late ChatRecord _currentChatRecord;
  final ChatService _chatService = ChatService();

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  void _endCall() {
    _timer.cancel();
    _chatService.addRecord(_currentChatRecord);
    Navigator.pop(context); // 直接關閉頁面
  }

  @override
  void initState() {
    super.initState();
    _currentChatRecord = ChatRecord(
      caller: widget.caller.name,
      topic: 'Call at ${DateTime.now()}', // You can customize the topic
    );
    _startCallTimer();
    _initializeTts();
    _initSpeechToText();
  }

  @override
  void dispose() {
    _timer.cancel();
    _ttsService.stop();
    super.dispose();
  }

  void _initializeTts() async {
    await _ttsService.initialize(widget.caller.voiceProfile);
    _ttsService.onStateChanged = (TtsState newState) {
      setState(() {
        ttsState = newState;
      });
    };
  }

  void _initSpeechToText() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _requestMessage = _lastWords;
    });
  }

  Future<void> _saveMessage() async {
    _ttsService.stop();

    setState(() {
      // _requestMessage = _messageController.text;
      _responseMessage = 'Processing...';
    });

    try {
      final response = await _chatGPTService.getChatResponse(_requestMessage);
      _responseMessage = response;
      _ttsService.speak(_responseMessage);
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
                  child: Text(
                    _lastWords,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              // If listening is active show the recognized words
              _speechToText.isListening
                  // ignore: unnecessary_string_interpolations
                  ? '$_lastWords'
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                  : _speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available',
              style: const TextStyle(color: Colors.white),
            ),
            FloatingActionButton(
              onPressed:
                  // If not yet listening for speech start, otherwise stop
                  _speechToText.isNotListening ? _startListening : _stopListening,
              tooltip: 'Listen',
              child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
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

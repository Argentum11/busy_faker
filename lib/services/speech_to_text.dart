import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  // Singleton instance
  static final SpeechToTextService _instance = SpeechToTextService._internal();
  factory SpeechToTextService() => _instance;
  SpeechToTextService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  void Function(bool)? updateSpeechStatus;
  void Function(SpeechRecognitionResult)? onSpeechResult;

  bool get isListening => _speechToText.isListening;
  bool get isNotListening => _speechToText.isNotListening;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    } else {
      _isInitialized = await _speechToText.initialize();
      updateSpeechStatus?.call(_isInitialized);
    }
  }

  Future<void> startListening() async {
    if (_isInitialized) {
      await _speechToText.listen(onResult: onSpeechResult, listenOptions: SpeechListenOptions());
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  void dispose() {
    // immediate terminates (does not deliver recognition results)
    _speechToText.cancel();

    _isInitialized = false;
  }
}

import 'package:flutter_tts/flutter_tts.dart';
import 'package:busy_faker/models/voice_profile.dart';
import 'dart:developer' as dev;

enum TtsState { playing, stopped }

class TtsService {
  // static: belongs to class (not instance)
  // final: can't be changed after initialization
  static final TtsService _instance = TtsService._internal();

  // return the singleton instance
  factory TtsService() => _instance;

  // definition of the constructor (empty)
  TtsService._internal();

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  void Function(TtsState)? onStateChanged;

  Future<void> initialize(VoiceProfile voiceProfile) async {
    flutterTts = FlutterTts();

    // Set speaking language to Chinese
    var languages = await flutterTts.getLanguages;
    if (languages.contains("zh-TW")) {
      await flutterTts.setLanguage("zh-TW");
      dev.log("Speaking language set to zh-TW successfully");
    } else {
      dev.log("Chinese language is not available on this device.");
      languages.forEach((lang) {
        dev.log("Available language: $lang");
      });
    }

    flutterTts.setStartHandler(() {
      _updateState(TtsState.playing);
      dev.log("Playing");
    });

    flutterTts.setCompletionHandler(() {
      _updateState(TtsState.stopped);
      dev.log("Complete");
    });

    flutterTts.setErrorHandler((msg) {
      _updateState(TtsState.stopped);
      dev.log("error: $msg");
    });

    await _setTtsConfiguration(voiceProfile);
  }

  void _updateState(TtsState newState) {
    ttsState = newState;
    onStateChanged?.call(newState);
  }

  Future<void> _setTtsConfiguration(VoiceProfile voiceProfile) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(voiceProfile.rate);
    await flutterTts.setPitch(voiceProfile.pitch);
  }

  List<String> _splitText(String text, {int maxLength = 300}) {
    final List<String> chunks = [];
    final RegExp regex = RegExp(r'(?<=\.|\?|!)\s');
    final List<String> sentences = text.split(regex);

    String currentChunk = '';
    for (String sentence in sentences) {
      if ((currentChunk.length + sentence.length) <= maxLength) {
        currentChunk += '$sentence ';
      } else {
        chunks.add(currentChunk.trim());
        currentChunk = '$sentence ';
      }
    }
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.trim());
    }

    return chunks;
  }

  Future<void> speak(String text) async {
    final cleanedText = text.replaceAll(RegExp(r'\*'), '');
    final List<String> textChunks = _splitText(cleanedText, maxLength: 300);

    for (String chunk in textChunks) {
      await flutterTts.speak(chunk);
      await flutterTts.awaitSpeakCompletion(true);
    }
  }

  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) _updateState(TtsState.stopped);
  }

  void dispose() {
    flutterTts.stop();
  }
}

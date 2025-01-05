class VoiceProfile {
  final String name;
  final double pitch;
  final double rate;

  static const minPitch = 0.5;
  static const maxPitch = 2.0;
  static const minRate = 0.0;
  static const maxRate = 1.0;

  VoiceProfile({
    required this.name,
    required double inputPitch,
    required double inputRate,
  })  : pitch = clampValue(inputPitch, minPitch, maxPitch),
        rate = clampValue(inputRate, minRate, maxRate);

  static double clampValue(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum);
  }
}

VoiceProfile robotVoice = VoiceProfile(name: "Robot voice", inputPitch: 0.5, inputRate: 0.7);
VoiceProfile hybridVoice = VoiceProfile(name: "Hybrid voice", inputPitch: 0.7, inputRate: 0.1);
VoiceProfile defaultVoice = VoiceProfile(name: "Default voice", inputPitch: 1.0, inputRate: 0.5);
VoiceProfile sopranoVoice = VoiceProfile(name: "Soprano voice", inputPitch: 2.0, inputRate: 0.5);

import 'package:busy_faker/models/voice_profile.dart';

class Caller {
  String name;
  String imagePath;
  VoiceProfile voiceProfile;

  Caller(
      {required this.name,
      required this.imagePath,
      required this.voiceProfile});
}

Caller heMo = Caller(
    name: '和默',
    imagePath: 'assets/images/character1.jpg',
    voiceProfile: robotVoice);
Caller qingYang = Caller(
    name: '清揚',
    imagePath: 'assets/images/character2.jpg',
    voiceProfile: hybridVoice);
Caller pingXin = Caller(
    name: '平心',
    imagePath: 'assets/images/character3.jpg',
    voiceProfile: defaultVoice);
Caller miaoGe = Caller(
    name: '妙歌',
    imagePath: 'assets/images/character4.jpg',
    voiceProfile: sopranoVoice);

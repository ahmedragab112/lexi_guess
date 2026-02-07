import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool soundEnabled = true;

  static Future<void> playCorrect() async {
    if (!soundEnabled) return;
    await _player.play(AssetSource('sounds/correct.mp3'));
  }

  static Future<void> playWin() async {
    if (!soundEnabled) return;
    await _player.play(AssetSource('sounds/win.mp3'));
  }

  static Future<void> playTap() async {
    if (!soundEnabled) return;
    // await _player.play(AssetSource('sounds/tap.mp3'));
  }
}

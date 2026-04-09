import 'package:just_audio/just_audio.dart';

class SfxService {
  final AudioPlayer _player = AudioPlayer();

  SfxService() {
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    try {
      // Предварительная загрузка звука для минимальной задержки
      await _player.setAsset('assets/audio/tap.mp3');
    } catch (e) {
      // ignore
    }
  }

  Future<void> playTap() async {
    try {
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setAsset('assets/audio/tap.mp3');
      await _player.play();
    } catch (e) {
      // ignore
    }
  }

  void dispose() {
    _player.dispose();
  }
}

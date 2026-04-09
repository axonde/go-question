import 'package:just_audio/just_audio.dart';

class SfxService {
  final AudioPlayer _player = AudioPlayer();
  bool _isEnabled = true;

  SfxService() {
    _loadSounds();
  }

  bool get isEnabled => _isEnabled;

  Future<void> setEnabled(bool value) async {
    _isEnabled = value;
    if (!value && _player.playing) {
      await _player.stop();
    }
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
    if (!_isEnabled) return;
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

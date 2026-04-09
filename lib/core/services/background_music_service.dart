import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService {
  final AudioPlayer _player;
  bool _isPlaying = false;

  BackgroundMusicService(this._player);

  bool get isPlaying => _isPlaying;

  Future<void> start({
    required String assetPath,
    double volume = 1.0,
    bool loop = true,
    Duration? startTime,
  }) async {
    if (_isPlaying) return;

    try {
      await _player.setVolume(volume);
      await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      await _player.play(AssetSource(assetPath));
      
      if (startTime != null) {
        await _player.seek(startTime);
      }
      
      _isPlaying = true;
    } catch (e) {
      // ignore
      print('BackgroundMusicService Error starting: $e');
    }
  }

  Future<void> stop() async {
    if (!_isPlaying) return;
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      // ignore
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      // ignore
    }
  }
}

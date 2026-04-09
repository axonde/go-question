import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundMusicService {
  final AudioPlayer _player;
  bool _isPlaying = false;
  String? _currentAsset;

  BackgroundMusicService(this._player);

  bool get isPlaying => _isPlaying;

  Future<void> start({
    required String assetPath,
    double volume = 1.0,
    bool loop = true,
    Duration? startTime,
  }) async {
    // Если уже играет тот же ассет — ничего не делаем
    if (_isPlaying && _currentAsset == assetPath) return;

    try {
      final fullPath = 'assets/$assetPath';

      // Если плеер занят — останавливаем
      if (_player.processingState != ProcessingState.idle) {
        await _player.stop();
      }

      await _player.setAsset(fullPath);
      _currentAsset = assetPath;

      await _player.setVolume(volume);
      await _player.setLoopMode(loop ? LoopMode.one : LoopMode.off);

      if (startTime != null && startTime > Duration.zero) {
        await _player.seek(startTime);
      }

      await _player.play();
      _isPlaying = true;
    } catch (e) {
      debugPrint('BackgroundMusicService Error starting: $e');
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('BackgroundMusicService Error stopping: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      // ignore
    }
  }

  void dispose() {
    _player.dispose();
  }
}

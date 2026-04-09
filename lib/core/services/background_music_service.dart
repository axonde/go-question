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
      // 0. Настраиваем глобальный контекст для микширования звука
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isMusicStream: true,
            audioFocus: AndroidAudioFocus.none, // Не перехватываем фокус
            usageType: AndroidUsageType.assistanceSonification,
            contentType: AndroidContentType.music,
            stayAwake: true,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient, // Позволяет микшировать
            options: {
              AVAudioSessionOptions.mixWithOthers,
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
        ),
      );

      // 1. Устанавливаем источник
      await _player.setSource(AssetSource(assetPath));
      
      // 2. Базовые настройки
      await _player.setVolume(volume);
      await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      
      // 3. Небольшая пауза для Android MediaPlayer (чтобы успел подготовиться)
      // Это критично для избежания IllegalStateException при вызове seek/resume
      await Future.delayed(const Duration(milliseconds: 200));

      // 4. Перемотка и старт
      if (startTime != null && startTime > Duration.zero) {
        await _player.seek(startTime);
      }
      
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      print('BackgroundMusicService Error starting: $e');
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      print('BackgroundMusicService Error stopping: $e');
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


import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class MusicaPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> iniciar() async {
    try {
      await _player.setAsset(
        'lib/assets/musica_superheroes.mp3',
      );

      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0.5);
      await _player.play();
    } catch (e) {
      debugPrint('Error al reproducir música: $e');
    }
  }
}

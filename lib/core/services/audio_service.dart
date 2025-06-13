import 'package:audioplayers/audioplayers.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class AudioService {
  static final AudioPlayer _backgroundPlayer = AudioPlayer();
  static final AudioPlayer _effectsPlayer = AudioPlayer();
  static double _backgroundVolume = 0.5;
  static double _effectsVolume = 1.0;

  static Future<void> initialize() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _effectsPlayer.setReleaseMode(ReleaseMode.release);
      await setBackgroundVolume(_backgroundVolume);
      await setEffectsVolume(_effectsVolume);
      AppLogger.info('AudioService initialized.');
    } catch (e) {
      AppLogger.error('Error initializing AudioService: $e');
    }
  }

  static Future<void> playBackgroundMusic(String assetPath) async {
    try {
      await _backgroundPlayer.play(AssetSource(assetPath));
      AppLogger.info('Playing background music: $assetPath');
    } catch (e) {
      AppLogger.error('Error playing background music ($assetPath): $e');
    }
  }

  static Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
      AppLogger.debug('Background music stopped.');
    } catch (e) {
      AppLogger.error('Error stopping background music: $e');
    }
  }

  static Future<void> pauseBackgroundMusic() async {
    try {
      await _backgroundPlayer.pause();
      AppLogger.debug('Background music paused.');
    } catch (e) {
      AppLogger.error('Error pausing background music: $e');
    }
  }

  static Future<void> resumeBackgroundMusic() async {
    try {
      await _backgroundPlayer.resume();
      AppLogger.debug('Background music resumed.');
    } catch (e) {
      AppLogger.error('Error resuming background music: $e');
    }
  }

  static Future<void> setBackgroundVolume(double volume) async {
    _backgroundVolume = volume.clamp(0.0, 1.0);
    try {
      await _backgroundPlayer.setVolume(_backgroundVolume);
      AppLogger.debug('Background volume set to: $_backgroundVolume');
    } catch (e) {
      AppLogger.error('Error setting background volume: $e');
    }
  }

  static double getBackgroundVolume() {
    return _backgroundVolume;
  }

  static Future<void> playSoundEffect(String assetPath) async {
    try {
      await _effectsPlayer.play(AssetSource(assetPath));
      AppLogger.debug('Playing sound effect: $assetPath');
    } catch (e) {
      AppLogger.error('Error playing sound effect ($assetPath): $e');
    }
  }

  static Future<void> setEffectsVolume(double volume) async {
    _effectsVolume = volume.clamp(0.0, 1.0);
    try {
      await _effectsPlayer.setVolume(_effectsVolume);
      AppLogger.debug('Effects volume set to: $_effectsVolume');
    } catch (e) {
      AppLogger.error('Error setting effects volume: $e');
    }
  }

  static double getEffectsVolume() {
    return _effectsVolume;
  }

  static Future<void> dispose() async {
    try {
      await _backgroundPlayer.dispose();
      await _effectsPlayer.dispose();
      AppLogger.info('AudioService disposed.');
    } catch (e) {
      AppLogger.error('Error disposing AudioService: $e');
    }
  }
}

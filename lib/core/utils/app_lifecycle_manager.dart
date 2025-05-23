import 'package:flutter/services.dart';
import 'package:immuno_warriors/core/services/audio_service.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';


class AppLifecycleManager {
  static Future<void> initializeApp() async {
    try {
      // Lock app orientation to landscape
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      AppLogger.info('App orientation locked to landscape.');

      // Initialize services
      await AudioService.initialize();
      await LocalStorageService.initialize();

      AppLogger.info('App services initialized.');
    } catch (e) {
      AppLogger.error('Error initializing app: $e');
      // Consider showing a user-friendly error message here
    }
  }

  static Future<void> disposeApp() async {
    try {
      await AudioService.dispose();
      AppLogger.info('App services disposed.');
    } catch (e) {
      AppLogger.error('Error disposing app: $e');
      // Consider logging or handling the error
    }
  }
}
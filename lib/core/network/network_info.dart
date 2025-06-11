/// Provides information about network connectivity for Immuno Warriors.
///
/// This file handles connectivity checks, network type detection, and offline mode support.
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity;

  /// Creates a [NetworkInfo] instance.
  ///
  /// Requires a [Connectivity] instance for network monitoring.
  NetworkInfo(this._connectivity);

  /// --- Connectivity Checks ---

  /// Checks if the device is connected to any network.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Determines the current network connection type.
  Future<String> get connectionType async {
    final result = await _connectivity.checkConnectivity();
    switch (result.first) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return 'Mobile';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.none:
        return 'None';
      default:
        return 'Unknown';
    }
  }

  /// Checks if the device has actual internet access by pinging a reliable endpoint.
  Future<bool> get isOnline async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// --- Event Streams ---

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// --- Offline Support ---

  /// Checks if offline mode is supported for a specific feature.
  ///
  /// [feature] specifies the game feature (e.g., 'combat_log', 'research_tree').
  bool isOfflineSupported(String feature) {
    // Define features that can function offline
    const offlineFeatures = {'combat_log', 'research_tree', 'war_archive'};
    return offlineFeatures.contains(feature);
  }
}

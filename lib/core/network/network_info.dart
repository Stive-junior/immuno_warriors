import 'package:connectivity_plus/connectivity_plus.dart';

/// Provides information about the network connectivity.
class NetworkInfo {
  final Connectivity connectivity;

  /// Creates a NetworkInfo instance.
  ///
  /// Requires a [Connectivity] instance.
  NetworkInfo(this.connectivity);

  /// Checks if the device is currently connected to the internet.
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Listens for changes in network connectivity.
  Stream<List<ConnectivityResult>> get onConnectivityChanged => connectivity.onConnectivityChanged;
}
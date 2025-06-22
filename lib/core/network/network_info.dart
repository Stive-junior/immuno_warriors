import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Vérifie si le dispositif est connecté à un réseau.
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      final connected = result.first != ConnectivityResult.none;
      AppLogger.info(
        'Vérification de la connectivité : ${connected ? "Connecté" : "Non connecté"}',
      );
      return connected;
    } catch (e) {
      AppLogger.error('Erreur lors de la vérification de la connectivité : $e');
      return false;
    }
  }

  /// Détermine le type de connexion réseau actuel.
  Future<String> get connectionType async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) {
        AppLogger.warning('Aucun type de connexion détecté.');
        return 'None';
      }
      final primaryResult = results.first;
      switch (primaryResult) {
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
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération du type de connexion : $e',
      );
      return 'Unknown';
    }
  }

  /// Vérifie si le dispositif a un accès Internet réel en pingant un endpoint fiable.
  Future<bool> get isOnline async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      final online = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      AppLogger.info(
        'Accès Internet : ${online ? "Disponible" : "Indisponible"}',
      );
      return online;
    } on SocketException catch (e) {
      AppLogger.error(
        'Erreur lors de la vérification de l\'accès Internet : $e',
      );
      return false;
    }
  }

  /// Vérifie si le réseau peut traiter des requêtes HTTP.
  Future<bool> canHandleRequests(String url) async {
    try {
      final response = await http
          .get(Uri.parse('$url/api/health'))
          .timeout(Duration(seconds: 5));
      final canHandle = response.statusCode == 200;
      AppLogger.info(
        'Capacité réseau pour $url : ${canHandle ? "OK" : "Échec"}',
      );
      return canHandle;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la vérification de la capacité réseau : $e',
      );
      return false;
    }
  }

  /// Vérifie si le dispositif est sur le même réseau Wi-Fi qu'une IP donnée.
  Future<bool> isOnSameWifi(String serverIp) async {
    try {
      if (await connectionType != 'Wi-Fi') {
        AppLogger.info(
          'Non connecté en Wi-Fi, impossible de vérifier le réseau commun.',
        );
        return false;
      }
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4 && !address.isLoopback) {
            final clientIp = address.address;
            final clientSubnet = _getSubnet(clientIp);
            final serverSubnet = _getSubnet(serverIp);
            final sameNetwork = clientSubnet == serverSubnet;
            AppLogger.info(
              'Vérification réseau commun : Client ($clientIp) vs Serveur ($serverIp) -> $sameNetwork',
            );
            return sameNetwork;
          }
        }
      }
      return false;
    } catch (e) {
      AppLogger.error('Erreur lors de la vérification du réseau commun : $e');
      return false;
    }
  }

  /// Extrait le sous-réseau d'une adresse IP (masque /24 par défaut).
  String _getSubnet(String ip) {
    final parts = ip.split('.');
    if (parts.length >= 3) {
      return '${parts[0]}.${parts[1]}.${parts[2]}';
    }
    return ip;
  }

  /// Flux des changements de connectivité.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Vérifie si le mode hors ligne est supporté pour une fonctionnalité spécifique.
  bool isOfflineSupported(String feature) {
    const offlineFeatures = {
      'combat_password',
      'password_archive',
      'weather_archive',
      'user_profile',
      'inventory',
      'achievements',
      'notifications',
    };
    final supported = offlineFeatures.contains(feature);
    AppLogger.info(
      'Fonctionnalité "$feature" supportée hors ligne : $supported',
    );
    return supported;
  }

  void dispose() {
    AppLogger.info('NetworkInfo nettoy.');
  }
}

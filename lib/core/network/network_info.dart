/// Fournit des informations sur la connectivité réseau pour Immuno Warriors.
///
/// Gère les vérifications de connectivité, la détection du type de réseau, et le support du mode hors ligne.
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class NetworkInfo {
  final Connectivity _connectivity;

  /// Crée une instance de [NetworkInfo].
  ///
  /// Requiert une instance de [Connectivity] pour surveiller le réseau.
  NetworkInfo(this._connectivity);

  /// --- Vérifications de connectivité ---

  /// Vérifie si le dispositif est connecté à un réseau.
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      final connected = result != ConnectivityResult.none;
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

  /// --- Flux d'événements ---

  /// Flux des changements de connectivité.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// --- Support hors ligne ---

  /// Vérifie si le mode hors ligne est supporté pour une fonctionnalité spécifique.
  ///
  /// [feature] spécifie la fonctionnalité du jeu (par exemple, 'combat_log', 'research_tree').
  bool isOfflineSupported(String feature) {
    const offlineFeatures = {
      'combat_log',
      'research_tree',
      'war_archive',
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

  /// Nettoie les ressources (optionnel).
  void dispose() {
    AppLogger.info('NetworkInfo nettoyé.');
  }
}

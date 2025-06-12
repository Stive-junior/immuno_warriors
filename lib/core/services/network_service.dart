import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/network_info.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';

/// Service de gestion de la connectivité réseau et de la disponibilité du serveur.
/// Fournit des fonctionnalités pour vérifier la connectivité, l'accessibilité du serveur,
/// gérer les URLs dynamiques, et supporter les modes hors ligne.
class NetworkService {
  final NetworkInfo _networkInfo;
  String _currentBaseUrl;
  final Dio _dio;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Constructeur du NetworkService.
  NetworkService({String? baseUrl})
    : _networkInfo = NetworkInfo(Connectivity()),
      _currentBaseUrl = baseUrl ?? _getBaseUrl(),
      _dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      ) {
    _setupConnectivityListener();
  }

  /// Obtient l'URL de base en fonction de l'environnement.
  static String _getBaseUrl() {
    const environment = String.fromEnvironment(
      'ENV',
      defaultValue: 'development',
    );
    const baseUrls = {
      'development': 'http://10.0.2.2:3000/api',
      'staging': 'https://staging.immuno-warriors.com/api',
      'production': 'https://api.immuno-warriors.com/api',
    };
    final selectedUrl = baseUrls[environment] ?? baseUrls['development']!;
    AppLogger.info(
      'URL de base sélectionnée pour l\'environnement $environment : $selectedUrl',
    );
    return selectedUrl;
  }

  /// Configure l'écouteur pour les changements de connectivité.
  void _setupConnectivityListener() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen((
      results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        AppLogger.warning('Connexion réseau perdue.');
      } else {
        AppLogger.info('Connexion réseau rétablie : $results');
        // Déclencher une tentative de synchronisation si nécessaire
        _notifyConnectivityRestored();
      }
    });
  }

  /// Notifie que la connectivité a été rétablie (peut être utilisé pour la synchronisation).
  void _notifyConnectivityRestored() {
    // Implémenter la logique de synchronisation ici si nécessaire
    // Par exemple, appeler un SyncService pour traiter la file d'attente
    AppLogger.info(
      'Tentative de synchronisation des données après rétablissement de la connexion.',
    );
  }

  /// Vérifie si le dispositif est connecté à un réseau.
  Future<bool> get isConnected async {
    try {
      final connected = await _networkInfo.isConnected;
      AppLogger.info(
        'Connectivité réseau : ${connected ? "Connecté" : "Non connecté"}',
      );
      return connected;
    } catch (e) {
      AppLogger.error('Erreur lors de la vérification de la connectivité : $e');
      throw NetworkException(
        'Erreur lors de la vérification de la connectivité réseau.',
      );
    }
  }

  /// Vérifie si le dispositif a un accès Internet réel.
  Future<bool> get isOnline async {
    try {
      final online = await _networkInfo.isOnline;
      AppLogger.info(
        'Accès Internet : ${online ? "Disponible" : "Indisponible"}',
      );
      return online;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la vérification de l\'accès Internet : $e',
      );
      throw NetworkException(
        'Erreur lors de la vérification de l\'accès Internet.',
      );
    }
  }

  /// Vérifie si le serveur API est accessible via une route /health.
  Future<bool> isServerReachable() async {
    if (!await isConnected) {
      AppLogger.warning(
        'Vérification de l\'accessibilité du serveur annulée : pas de connexion réseau.',
      );
      throw NoInternetException();
    }
    if (!await isOnline) {
      AppLogger.warning(
        'Vérification de l\'accessibilité du serveur annulée : pas d\'accès Internet.',
      );
      throw NoInternetException();
    }

    try {
      final response = await _dio.get(
        '$_currentBaseUrl/v1/health',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      final isReachable = response.statusCode == 200;
      AppLogger.info(
        'Serveur API accessible : $isReachable (URL: $_currentBaseUrl/v1/health)',
      );
      return isReachable;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la vérification de l\'accessibilité du serveur : $e',
      );
      throw ServerUnreachableException();
    }
  }

  /// Change l'URL de base de l'API.
  void setBaseUrl(String newUrl) {
    _currentBaseUrl = newUrl;
    // Mettre à jour l'URL dans DioClient si nécessaire
    AppLogger.info('URL de base de l\'API changée : $newUrl');
  }

  /// Obtient l'URL de base actuelle.
  String get currentBaseUrl => _currentBaseUrl;

  /// Vérifie si une fonctionnalité est supportée hors ligne.
  bool isOfflineSupported(String feature) {
    final supported = _networkInfo.isOfflineSupported(feature);
    AppLogger.info(
      'Fonctionnalité "$feature" supportée hors ligne : $supported',
    );
    return supported;
  }

  /// Obtient le type de connexion actuel.
  Future<String> getConnectionType() async {
    try {
      final type = await _networkInfo.connectionType;
      AppLogger.info('Type de connexion réseau : $type');
      return type;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération du type de connexion : $e',
      );
      return 'Inconnu';
    }
  }

  /// Stream des changements de connectivité.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _networkInfo.onConnectivityChanged;

  /// Nettoie les ressources (par exemple, ferme les abonnements).
  void dispose() {
    _connectivitySubscription?.cancel();
    AppLogger.info('NetworkService nettoyé : abonnements fermés.');
  }
}

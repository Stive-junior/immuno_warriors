import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/network_info.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:rxdart/rxdart.dart';

class NetworkService {
  final NetworkInfo _networkInfo;
  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final Ref _ref;
  final BehaviorSubject<String> _baseUrlSubject = BehaviorSubject.seeded('');
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  NetworkService({
    required NetworkInfo networkInfo,
    required FirebaseFirestore firestore,
    required Ref ref,
  }) : _networkInfo = networkInfo,
       _firestore = firestore,
       _ref = ref {
    _initialize();
  }

  NetworkInfo get networkInfo => _networkInfo;
  String get baseUrl => _baseUrlSubject.value;
  Stream<String> get baseUrlStream => _baseUrlSubject.stream;

  Future<void> _initialize() async {
    await _updateBaseUrl();
    _listenToBaseUrlChanges();
  }

  Future<void> _updateBaseUrl() async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        if (!await _networkInfo.isOnline) {
          AppLogger.warning('Pas de connexion internet pour récupérer l\'URL.');
          throw NetworkException('Pas de connexion internet');
        }

        final doc = await _firestore.collection('config').doc('api').get();
        if (doc.exists && doc.data()?['baseUrl'] != null) {
          final baseUrl = doc.data()!['baseUrl'] as String;
          final status = doc.data()!['status'] as String;
          final isLocal = status == 'local';
          bool isValidUrl = false;

          if (!ApiEndpoints.isValidUrl(baseUrl)) {
            AppLogger.warning('URL invalide dans Firestore: $baseUrl');
            throw Exception('URL invalide: $baseUrl');
          }

          if (isLocal) {
            final serverIp = _extractIpFromUrl(baseUrl);
            if (serverIp != null && await _networkInfo.isOnSameWifi(serverIp)) {
              isValidUrl = await _networkInfo.canHandleRequests(baseUrl);
            }
          } else {
            isValidUrl = await _networkInfo.canHandleRequests(baseUrl);
          }

          if (isValidUrl) {
            _baseUrlSubject.add(baseUrl);
            AppLogger.info(
              'URL de base mise à jour: $baseUrl (statut: $status)',
            );
            return;
          } else {
            AppLogger.warning('URL injoignable: $baseUrl');
            throw Exception('URL injoignable: $baseUrl');
          }
        } else {
          AppLogger.warning('Aucune URL dans Firestore.');
          throw Exception('Aucune URL trouvée dans Firestore');
        }
      } catch (e) {
        AppLogger.error('Échec récupération URL ($attempt/$_maxRetries): $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
        } else {
          AppLogger.error('Max réessais atteint pour récupération URL.');
        }
      }
    }

    const defaultUrl = 'https://api.immunowarriors.com';
    if (_baseUrlSubject.value != defaultUrl) {
      _baseUrlSubject.add(defaultUrl);
      AppLogger.warning('Utilisation URL par défaut: $defaultUrl');
    }
  }

  void _listenToBaseUrlChanges() {
    _firestore
        .collection('config')
        .doc('api')
        .snapshots()
        .listen(
          (snapshot) async {
            if (snapshot.exists && snapshot.data()?['baseUrl'] != null) {
              final baseUrl = snapshot.data()!['baseUrl'] as String;
              final status = snapshot.data()!['status'] as String;
              final isLocal = status == 'local';
              bool isValidUrl = false;

              if (!ApiEndpoints.isValidUrl(baseUrl)) {
                AppLogger.warning('URL invalide en temps réel: $baseUrl');
                return;
              }

              if (isLocal) {
                final serverIp = _extractIpFromUrl(baseUrl);
                if (serverIp != null &&
                    await _networkInfo.isOnSameWifi(serverIp)) {
                  isValidUrl = await _networkInfo.canHandleRequests(baseUrl);
                }
              } else {
                isValidUrl = await _networkInfo.canHandleRequests(baseUrl);
              }

              if (isValidUrl && baseUrl != _baseUrlSubject.value) {
                _baseUrlSubject.add(baseUrl);
                AppLogger.info(
                  'URL mise à jour en temps réel: $baseUrl (statut: $status)',
                );
              } else if (!isValidUrl) {
                AppLogger.warning(
                  'Mise à jour URL ignorée: URL injoignable pour $baseUrl',
                );
              }
            } else {
              AppLogger.warning('Document config ou champ baseUrl inexistant.');
            }
          },
          onError: (e) {
            AppLogger.error('Erreur écoute changements URL: $e');
          },
        );
  }

  String? _extractIpFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.host.isNotEmpty) {
      final ip = uri.host;
      if (RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$').hasMatch(ip)) {
        return ip;
      }
    }
    return null;
  }

  void setBaseUrl(String url) {
    if (!ApiEndpoints.isValidUrl(url)) {
      AppLogger.error('URL invalide pour définition manuelle: $url');
      throw NetworkException('URL invalide: $url');
    }
    if (_baseUrlSubject.value != url) {
      _baseUrlSubject.add(url);
      AppLogger.info('URL de base définie manuellement: $url');
    } else {
      AppLogger.info('URL déjà définie à: $url (ignorée)');
    }
  }

  Future<bool> isServerReachable() async {
    try {
      final reachable = await _networkInfo.canHandleRequests(baseUrl);
      AppLogger.debug(
        'Vérification accessibilité serveur $baseUrl: $reachable',
      );
      return reachable;
    } catch (e) {
      AppLogger.error('Erreur vérification accessibilité $baseUrl: $e');
      return false;
    }
  }

  bool isOfflineSupported(String feature) {
    final supported = _networkInfo.isOfflineSupported(feature);
    AppLogger.debug('Support hors ligne pour "$feature": $supported');
    return supported;
  }

  void dispose() {
    _baseUrlSubject.close();
    AppLogger.info('NetworkService disposé.');
  }

  Future<bool> get isOnline async {
    try {
      final online = await _networkInfo.isOnline;
      AppLogger.info(
        'Accès internet: ${online ? "Disponible" : "Indisponible"}',
      );
      return online;
    } catch (e) {
      AppLogger.error('Erreur vérification accès internet: $e');
      throw NetworkException('Erreur vérification accès internet.');
    }
  }

  Future<bool> get isConnected async {
    try {
      final connected = await _networkInfo.isConnected;
      AppLogger.info(
        'Connectivité réseau: ${connected ? "Connecté" : "Non connecté"}',
      );
      return connected;
    } catch (e) {
      AppLogger.error('Erreur vérification connectivité: $e');
      throw NetworkException('Erreur vérification connectivité réseau.');
    }
  }
}

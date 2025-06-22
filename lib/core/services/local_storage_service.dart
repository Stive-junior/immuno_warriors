import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/data/models/multiplayer_session_model.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/data/models/pathogen_model.dart';
import 'package:immuno_warriors/data/models/antibody_model.dart';
import 'package:immuno_warriors/data/models/research_model.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/data/api/gemini_response.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';
import 'package:immuno_warriors/data/models/cached_session.dart';
import 'package:immuno_warriors/data/models/memory_signature_model.dart';
import 'package:immuno_warriors/data/models/notification_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';
import 'package:immuno_warriors/data/models/leaderboard_model.dart';
import 'package:immuno_warriors/data/models/progression_model.dart';

/// Service de stockage local utilisant Hive pour gérer les données hors ligne.
/// Supporte la persistance des données utilisateur, combats, recherches, notifications, etc.
class LocalStorageService {
  // Noms des boîtes Hive
  static const String _userBoxName = 'user';
  static const String _memoryBoxName = 'memory';
  static const String _combatBoxName = 'combat';
  static const String _researchBoxName = 'research';
  static const String _geminiBoxName = 'gemini';
  static const String _combatReportBoxName = 'combatReports';
  static const String _baseViraleBoxName = 'baseVirales';
  static const String _usersCacheBoxName = 'usersCache';
  static const String _currentUserCacheBoxName = 'currentUserCache';
  static const String _sessionBoxName = 'session';
  static const String _generalDataBoxName = 'generalData';
  static const String _inventoryBoxName = 'inventory';
  static const String _achievementsBoxName = 'achievements';
  static const String _notificationsBoxName = 'notifications';
  static const String _progressionBoxName = 'progression';
  static const String _threatsBoxName = 'threats';
  static const String _antibodiesBoxName = 'antibodies';
  static const String _pathogensBoxName = 'pathogens';
  static const String _leaderboardBoxName = 'leaderboard';
  static const String _multiplayerBoxName = 'multiplayer';
  static const String _syncQueueBoxName = 'syncQueue';

  // Constructeur privé pour le pattern singleton
  LocalStorageService._internal();

  // Instance unique du service
  static final LocalStorageService _instance = LocalStorageService._internal();

  // Factory pour obtenir l'instance unique
  factory LocalStorageService() => _instance;

  /// Initialise Hive et enregistre les adaptateurs nécessaires.
  static Future<void> initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      // Enregistrement des adaptateurs
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(PathogenModelAdapter());
      Hive.registerAdapter(AntibodyModelAdapter());
      Hive.registerAdapter(ResearchModelAdapter());
      Hive.registerAdapter(GeminiResponseAdapter());
      Hive.registerAdapter(CombatReportModelAdapter());
      Hive.registerAdapter(BaseViraleModelAdapter());
      Hive.registerAdapter(CachedSessionAdapter());
      Hive.registerAdapter(MemorySignatureModelAdapter());
      Hive.registerAdapter(NotificationModelAdapter());
      Hive.registerAdapter(MultiplayerSessionModelAdapter()); // Ajouté
      Hive.registerAdapter(InventoryItemModelAdapter()); // Ajouté
      Hive.registerAdapter(LeaderboardModelAdapter()); // Ajouté
      Hive.registerAdapter(ProgressionModelAdapter()); // Ajouté

      await _openBoxes();
      AppLogger.info('Initialisation de Hive réussie.');
    } catch (e) {
      AppLogger.error('Erreur lors de l\'initialisation de Hive : $e');
      throw Exception(AppStrings.hiveInitializationFailed);
    }
  }

  /// Ouvre toutes les boîtes Hive nécessaires.
  static Future<void> _openBoxes() async {
    try {
      await Hive.openBox<UserModel>(_userBoxName);
      await Hive.openBox<List<MemorySignatureModel>>(_memoryBoxName);
      await Hive.openBox<List<dynamic>>(
        _combatBoxName,
      ); // Gardé comme dynamic pour compatibilité
      await Hive.openBox<List<ResearchModel>>(_researchBoxName);
      await Hive.openBox<List<GeminiResponse>>(_geminiBoxName);
      await Hive.openBox<CombatReportModel>(_combatReportBoxName);
      await Hive.openBox<BaseViraleModel>(_baseViraleBoxName);
      await Hive.openBox<List<UserEntity>>(_usersCacheBoxName);
      await Hive.openBox<UserEntity>(_currentUserCacheBoxName);
      await Hive.openBox<CachedSession>(_sessionBoxName);
      await Hive.openBox<dynamic>(_generalDataBoxName);
      await Hive.openBox<List<InventoryItemModel>>(
        _inventoryBoxName,
      ); // Typé correctement
      await Hive.openBox<List<Map<String, dynamic>>>(
        _achievementsBoxName,
      ); // Typé comme Map
      await Hive.openBox<List<NotificationModel>>(_notificationsBoxName);
      await Hive.openBox<ProgressionModel>(
        _progressionBoxName,
      ); // Typé correctement
      await Hive.openBox<List<Map<String, dynamic>>>(
        _threatsBoxName,
      ); // Typé comme Map
      await Hive.openBox<List<AntibodyModel>>(_antibodiesBoxName);
      await Hive.openBox<List<PathogenModel>>(_pathogensBoxName);
      await Hive.openBox<List<LeaderboardModel>>(
        _leaderboardBoxName,
      ); // Typé correctement
      await Hive.openBox<List<MultiplayerSessionModel>>(
        _multiplayerBoxName,
      ); // Typé correctement
      await Hive.openBox<List<Map<String, dynamic>>>(_syncQueueBoxName);
      AppLogger.info('Boîtes Hive ouvertes avec succès.');
    } catch (e) {
      AppLogger.error('Erreur lors de l\'ouverture des boîtes Hive : $e');
      throw Exception(AppStrings.hiveInitializationFailed);
    }
  }

  /// Opération générique sur une boîte Hive avec gestion des erreurs.
  Future<T?> _boxOperation<T>(
    String boxName,
    String key,
    Future<T> Function(Box box, String key) operation, {
    T? defaultValue,
  }) async {
    try {
      final box = Hive.box(boxName);
      if (!box.containsKey(key) && defaultValue != null) {
        return defaultValue;
      }
      return await operation(box, key);
    } catch (e) {
      AppLogger.error(
        'Erreur dans l\'opération sur la boîte $boxName avec la clé $key : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des données générales ====================

  /// Sauvegarde des données générales non liées à un utilisateur.
  Future<void> saveData(String key, dynamic value) async {
    try {
      await _boxOperation<void>(_generalDataBoxName, key, (box, key) async {
        await box.put(key, value);
        AppLogger.info('Données générales sauvegardées pour la clé : $key');
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde des données générales : $e',
      );
      rethrow;
    }
  }

  /// Récupère des données générales.
  Future<dynamic> getData(String key) async {
    try {
      return await _boxOperation<dynamic>(_generalDataBoxName, key, (
        box,
        key,
      ) async {
        final value = box.get(key);
        AppLogger.info('Données générales récupérées pour la clé : $key');
        return value;
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des données générales : $e',
      );
      rethrow;
    }
  }

  /// Supprime des données générales.
  Future<void> clearData(String key) async {
    try {
      await _boxOperation<void>(_generalDataBoxName, key, (box, key) async {
        await box.delete(key);
        AppLogger.info('Données générales supprimées pour la clé : $key');
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression des données générales : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des utilisateurs ====================

  /// Sauvegarde un utilisateur localement.
  Future<void> saveUser(UserModel user) async {
    try {
      await _boxOperation<void>(_userBoxName, user.id, (box, key) async {
        await box.put(key, user);
        AppLogger.info('Utilisateur sauvegardé localement : ${user.id}');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde de l\'utilisateur : $e');
      rethrow;
    }
  }

  UserModel? getUser(String userId) {
    try {
      return _boxOperation<UserModel?>(_userBoxName, userId, (box, key) async {
            return box.get(key) as UserModel?;
          })
          as UserModel;
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de l\'utilisateur : $e');
      rethrow;
    }
  }

  /// Supprime un utilisateur localement.
  Future<void> clearUser(String userId) async {
    try {
      await _boxOperation<void>(_userBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info('Utilisateur supprimé localement : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression de l\'utilisateur : $e');
      rethrow;
    }
  }

  // ==================== Gestion des signatures de mémoire ====================

  /// Sauvegarde les signatures mémoire de l'utilisateur.
  Future<void> saveMemorySignatures(
    String userId,
    List<MemorySignatureModel> signatures,
  ) async {
    try {
      await _boxOperation<void>(_memoryBoxName, userId, (box, key) async {
        await box.put(key, signatures);
        AppLogger.info(
          'Signatures mémoire sauvegardées pour l\'utilisateur : $userId, ${signatures.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde des signatures mémoire : $e',
      );
      rethrow;
    }
  }

  /// Sauvegarde une signature de mémoire.
  Future<void> saveMemorySignature(
    String userId,
    MemorySignatureModel signature,
  ) async {
    try {
      await _boxOperation<void>(_memoryBoxName, userId, (box, key) async {
        final signatures = (box.get(key) as List<MemorySignatureModel>?) ?? [];
        signatures.add(signature);
        await box.put(key, signatures);
        AppLogger.info(
          'Signature de mémoire sauvegardée pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde d\'une signature mémoire : $e',
      );
      rethrow;
    }
  }

  /// Récupère les signatures de mémoire d'un utilisateur.
  Future<List<MemorySignatureModel>?> getMemorySignatures(String userId) async {
    try {
      return await _boxOperation<List<MemorySignatureModel>>(
        _memoryBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<MemorySignatureModel>?) ?? [];
        },
        defaultValue: <MemorySignatureModel>[],
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des signatures mémoire : $e',
      );
      rethrow;
    }
  }

  /// Supprime les signatures de mémoire d'un utilisateur.
  Future<void> clearMemorySignatures(String userId) async {
    try {
      await _boxOperation<void>(_memoryBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info(
          'Signatures de mémoire supprimées pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression des signatures mémoire : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion de l'arbre de recherche ====================

  /// Sauvegarde l'arbre de recherche d'un utilisateur.
  Future<void> saveResearchTree(String userId, List<ResearchModel> tree) async {
    try {
      await _boxOperation<void>(_researchBoxName, 'tree_$userId', (
        box,
        key,
      ) async {
        await box.put(key, tree);
        AppLogger.info(
          'Arbre de recherche sauvegardé pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde de l\'arbre de recherche : $e',
      );
      rethrow;
    }
  }

  /// Récupère l'arbre de recherche d'un utilisateur.
  Future<List<ResearchModel>?> getResearchTree(String userId) async {
    try {
      return await _boxOperation<List<ResearchModel>>(
        _researchBoxName,
        'tree_$userId',
        (box, key) async {
          return (box.get(key) as List<ResearchModel>?) ?? [];
        },
        defaultValue: <ResearchModel>[],
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération de l\'arbre de recherche : $e',
      );
      rethrow;
    }
  }

  /// Sauvegarde la progression des recherches d'un utilisateur.
  Future<void> saveResearchProgress(
    String userId,
    Map<String, dynamic> progress,
  ) async {
    try {
      await _boxOperation<void>(_researchBoxName, 'progress_$userId', (
        box,
        key,
      ) async {
        await box.put(key, progress);
        AppLogger.info(
          'Progression des recherches sauvegardée pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde de la progression des recherches : $e',
      );
      rethrow;
    }
  }

  /// Récupère la progression des recherches d'un utilisateur.
  Future<Map<String, dynamic>?> getResearchProgress(String userId) async {
    try {
      return await _boxOperation<Map<String, dynamic>?>(
        _researchBoxName,
        'progress_$userId',
        (box, key) async {
          return box.get(key) as Map<String, dynamic>?;
        },
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération de la progression des recherches : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des combats ====================

  /// Sauvegarde les données d'un combat.
  Future<void> saveCombatData(String userId, dynamic combatData) async {
    try {
      await _boxOperation<void>(_combatBoxName, userId, (box, key) async {
        final combatDataList = (box.get(key) as List<dynamic>?) ?? [];
        combatDataList.add(combatData);
        await box.put(key, combatDataList);
        AppLogger.info(
          'Données de combat sauvegardées pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde des données de combat : $e',
      );
      rethrow;
    }
  }

  /// Récupère les données des combats d'un utilisateur.
  Future<List<dynamic>?> getCombatData(String userId) async {
    try {
      return await _boxOperation<List<dynamic>>(_combatBoxName, userId, (
        box,
        key,
      ) async {
        return (box.get(key) as List<dynamic>?) ?? [];
      }, defaultValue: <dynamic>[]);
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des données de combat : $e',
      );
      rethrow;
    }
  }

  /// Supprime les données des combats d'un utilisateur.
  Future<void> clearCombatData(String userId) async {
    try {
      await _boxOperation<void>(_combatBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info(
          'Données de combat supprimées pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression des données de combat : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des rapports de combat ====================

  /// Sauvegarde un rapport de combat.
  Future<void> saveCombatReport(String userId, CombatReportModel report) async {
    try {
      final userKey = '$userId-${report.id}';
      await _boxOperation<void>(_combatReportBoxName, userKey, (
        box,
        key,
      ) async {
        await box.put(key, report);
        AppLogger.info('Rapport de combat sauvegardé : $userKey');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde du rapport de combat : $e');
      rethrow;
    }
  }

  /// Récupère un rapport de combat spécifique.
  CombatReportModel? getCombatReport(String userId, String combatId) {
    try {
      final userKey = '$userId-$combatId';
      return _boxOperation<CombatReportModel?>(_combatReportBoxName, userKey, (
            box,
            key,
          ) async {
            return box.get(key) as CombatReportModel?;
          })
          as CombatReportModel;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération du rapport de combat : $e',
      );
      rethrow;
    }
  }

  /// Récupère tous les rapports de combat d'un utilisateur.
  Future<List<CombatReportModel>> getAllCombatReports(String userId) async {
    try {
      final box = Hive.box(_combatReportBoxName);
      final reports = <CombatReportModel>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          final report = box.get(key);
          if (report is CombatReportModel) {
            reports.add(report);
          }
        }
      }
      AppLogger.info(
        'Récupération de tous les rapports de combat pour l\'utilisateur : $userId',
      );
      return reports;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des rapports de combat : $e',
      );
      rethrow;
    }
  }

  /// Supprime tous les rapports de combat d'un utilisateur.
  Future<void> clearCombatReports(String userId) async {
    try {
      final box = Hive.box(_combatReportBoxName);
      final keysToRemove = <dynamic>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          keysToRemove.add(key);
        }
      }
      await box.deleteAll(keysToRemove);
      AppLogger.info(
        'Rapports de combat supprimés pour l\'utilisateur : $userId',
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression des rapports de combat : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des bases virales ====================

  /// Sauvegarde une base virale.
  Future<void> saveBaseVirale(String userId, BaseViraleModel base) async {
    try {
      final userKey = '$userId-${base.id}';
      await _boxOperation<void>(_baseViraleBoxName, userKey, (box, key) async {
        await box.put(key, base);
        AppLogger.info('Base virale sauvegardée : $userKey');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde de la base virale : $e');
      rethrow;
    }
  }

  /// Récupère une base virale spécifique.
  Future<BaseViraleModel?> getBaseVirale(String userId, String baseId) async {
    try {
      final userKey = '$userId-$baseId';
      return await _boxOperation<BaseViraleModel?>(
        _baseViraleBoxName,
        userKey,
        (box, key) async {
          return box.get(key) as BaseViraleModel?;
        },
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de la base virale : $e');
      rethrow;
    }
  }

  /// Récupère toutes les bases virales d'un utilisateur.
  Future<List<BaseViraleModel>> getAllBasesVirales(String userId) async {
    try {
      final box = Hive.box(_baseViraleBoxName);
      final bases = <BaseViraleModel>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          final base = box.get(key);
          if (base is BaseViraleModel) {
            bases.add(base);
          }
        }
      }
      AppLogger.info(
        'Récupération de toutes les bases virales pour l\'utilisateur : $userId',
      );
      return bases;
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des bases virales : $e');
      rethrow;
    }
  }

  /// Supprime toutes les bases virales d'un utilisateur.
  Future<void> clearBasesVirales(String userId) async {
    try {
      final box = Hive.box(_baseViraleBoxName);
      final keysToRemove = <dynamic>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          keysToRemove.add(key);
        }
      }
      await box.deleteAll(keysToRemove);
      AppLogger.info('Bases virales supprimées pour l\'utilisateur : $userId');
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression des bases virales : $e');
      rethrow;
    }
  }

  // ==================== Gestion de l'inventaire ====================

  /// Sauvegarde l'inventaire complet d'un utilisateur.
  Future<void> saveInventory(
    String userId,
    List<InventoryItemModel> inventory,
  ) async {
    try {
      await _boxOperation<void>(_inventoryBoxName, userId, (box, key) async {
        await box.put(key, inventory);
        AppLogger.info(
          'Inventaire complet sauvegardé pour l\'utilisateur : $userId, ${inventory.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde de l\'inventaire : $e');
      rethrow;
    }
  }

  /// Sauvegarde un élément d'inventaire.
  Future<void> saveInventoryItem(String userId, InventoryItemModel item) async {
    try {
      await _boxOperation<void>(_inventoryBoxName, userId, (box, key) async {
        final items = (box.get(key) as List<InventoryItemModel>?) ?? [];
        items.add(item);
        await box.put(key, items);
        AppLogger.info(
          'Élément d\'inventaire sauvegardé pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde d\'un élément d\'inventaire : $e',
      );
      rethrow;
    }
  }

  /// Récupère l'inventaire d'un utilisateur.
  Future<List<InventoryItemModel>?> getInventory(String userId) async {
    try {
      return await _boxOperation<List<InventoryItemModel>>(
        _inventoryBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<InventoryItemModel>?) ?? [];
        },
        defaultValue: <InventoryItemModel>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de l\'inventaire : $e');
      rethrow;
    }
  }

  /// Supprime un élément d'inventaire.
  Future<void> removeInventoryItem(String userId, String itemId) async {
    try {
      await _boxOperation<void>(_inventoryBoxName, userId, (box, key) async {
        if (itemId == 'all') {
          await box.put(key, []);
        } else {
          final items = (box.get(key) as List<InventoryItemModel>?) ?? [];
          items.removeWhere((item) => item.id == itemId);
          await box.put(key, items);
        }
        AppLogger.info(
          'Élément d\'inventaire supprimé : $itemId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression d\'un élément d\'inventaire : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des réalisations ====================

  /// Sauvegarde une réalisation.
  Future<void> saveAchievement(
    String userId,
    Map<String, dynamic> achievement,
  ) async {
    try {
      await _boxOperation<void>(_achievementsBoxName, userId, (box, key) async {
        final achievements =
            (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        achievements.add(achievement);
        await box.put(key, achievements);
        AppLogger.info('Réalisation sauvegardée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde d\'une réalisation : $e');
      rethrow;
    }
  }

  /// Récupère les réalisations d'un utilisateur.
  Future<List<Map<String, dynamic>>?> getAchievements(String userId) async {
    try {
      return await _boxOperation<List<Map<String, dynamic>>>(
        _achievementsBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        },
        defaultValue: <Map<String, dynamic>>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des réalisations : $e');
      rethrow;
    }
  }

  /// Supprime une réalisation.
  Future<void> removeAchievement(String userId, String achievementId) async {
    try {
      await _boxOperation<void>(_achievementsBoxName, userId, (box, key) async {
        final achievements =
            (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        achievements.removeWhere(
          (achievement) => achievement['id'] == achievementId,
        );
        await box.put(key, achievements);
        AppLogger.info(
          'Réalisation supprimée : $achievementId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression d\'une réalisation : $e');
      rethrow;
    }
  }

  /// Récupère une réalisation spécifique d'un utilisateur.
  Future<Map<String, dynamic>?> getAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      return await _boxOperation<Map<String, dynamic>?>(
        _achievementsBoxName,
        userId,
        (box, key) async {
          final achievements =
              (box.get(key) as List<Map<String, dynamic>>?) ?? [];

          /// junior
          final achievement = achievements.firstWhere(
            (achievement) => achievement['id'] == achievementId,
            orElse: () => throw Exception('Accomplissement non trouvé'),
          );
          return achievement as Map<String, dynamic>?;
        },
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération d\'une réalisation : $e');
      rethrow;
    }
  }

  // ==================== Gestion des notifications ====================

  /// Sauvegarde les notifications de l'utilisateur.
  Future<void> saveNotifications(
    String userId,
    List<NotificationModel> notifications,
  ) async {
    try {
      await _boxOperation<void>(_notificationsBoxName, userId, (
        box,
        key,
      ) async {
        await box.put(key, notifications);
        AppLogger.info(
          'Notifications sauvegardées pour l\'utilisateur : $userId, ${notifications.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde des notifications : $e');
      rethrow;
    }
  }

  /// Sauvegarde une notification.
  Future<void> saveNotification(
    String userId,
    NotificationModel notification,
  ) async {
    try {
      await _boxOperation<void>(_notificationsBoxName, userId, (
        box,
        key,
      ) async {
        final notifications = (box.get(key) as List<NotificationModel>?) ?? [];
        notifications.add(notification);
        await box.put(key, notifications);
        AppLogger.info(
          'Notification sauvegardée pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde d\'une notification : $e');
      rethrow;
    }
  }

  /// Récupère les notifications d'un utilisateur.
  Future<List<NotificationModel>?> getNotifications(String userId) async {
    try {
      return await _boxOperation<List<NotificationModel>>(
        _notificationsBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<NotificationModel>?) ?? [];
        },
        defaultValue: <NotificationModel>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des notifications : $e');
      rethrow;
    }
  }

  /// Supprime une notification.
  Future<void> removeNotification(String userId, String notificationId) async {
    try {
      await _boxOperation<void>(_notificationsBoxName, userId, (
        box,
        key,
      ) async {
        final notifications = (box.get(key) as List<NotificationModel>?) ?? [];
        notifications.removeWhere(
          (notification) => notification.id == notificationId,
        );
        await box.put(key, notifications);
        AppLogger.info(
          'Notification supprimée : $notificationId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression d\'une notification : $e');
      rethrow;
    }
  }

  // ==================== Gestion de la progression ====================

  /// Sauvegarde la progression d'un utilisateur.
  Future<void> saveProgression(
    String userId,
    ProgressionModel progression,
  ) async {
    try {
      await _boxOperation<void>(_progressionBoxName, userId, (box, key) async {
        await box.put(key, progression);
        AppLogger.info('Progression sauvegardée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde de la progression : $e');
      rethrow;
    }
  }

  /// Récupère la progression d'un utilisateur.
  Future<ProgressionModel?> getProgression(String userId) async {
    try {
      return await _boxOperation<ProgressionModel?>(
        _progressionBoxName,
        userId,
        (box, key) async {
          return box.get(key) as ProgressionModel?;
        },
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de la progression : $e');
      rethrow;
    }
  }

  /// Supprime la progression d'un utilisateur.
  Future<void> clearProgression(String userId) async {
    try {
      await _boxOperation<void>(_progressionBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info('Progression supprimée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression de la progression : $e');
      rethrow;
    }
  }

  // ==================== Gestion des menaces ====================

  /// Sauvegarde les menaces de l'utilisateur.
  Future<void> saveThreats(
    String userId,
    List<Map<String, dynamic>> threats,
  ) async {
    try {
      await _boxOperation<void>(_threatsBoxName, userId, (box, key) async {
        await box.put(key, threats);
        AppLogger.info(
          'Menaces sauvegardées pour l\'utilisateur : $userId, ${threats.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde des menaces : $e');
      rethrow;
    }
  }

  /// Sauvegarde une menace.
  Future<void> saveThreat(String userId, Map<String, dynamic> threat) async {
    try {
      await _boxOperation<void>(_threatsBoxName, userId, (box, key) async {
        final threats = (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        threats.add(threat);
        await box.put(key, threats);
        AppLogger.info('Menace sauvegardée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde d\'une menace : $e');
      rethrow;
    }
  }

  /// Récupère les menaces d'un utilisateur.
  Future<List<Map<String, dynamic>>?> getThreats(String userId) async {
    try {
      return await _boxOperation<List<Map<String, dynamic>>>(
        _threatsBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        },
        defaultValue: <Map<String, dynamic>>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des menaces : $e');
      rethrow;
    }
  }

  /// Récupère une menace spécifique d'un utilisateur.
  Future<Map<String, dynamic>?> getThreat(
    String userId,
    String threatId,
  ) async {
    try {
      return await _boxOperation<Map<String, dynamic>?>(
        _threatsBoxName,
        userId,
        (box, key) async {
          final threats = (box.get(key) as List<Map<String, dynamic>>?) ?? [];
          final threat = threats.firstWhere(
            (threat) => threat['id'] == threatId,
            orElse: () => throw Exception('Ménace non trouvé'),
          );
          return threat as Map<String, dynamic>?;
        },
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération d\'une menace : $e');
      rethrow;
    }
  }

  /// Supprime une menace.
  Future<void> removeThreat(String userId, String threatId) async {
    try {
      await _boxOperation<void>(_threatsBoxName, userId, (box, key) async {
        final threats = (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        threats.removeWhere((threat) => threat['id'] == threatId);
        await box.put(key, threats);
        AppLogger.info(
          'Menace supprimée : $threatId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression d\'une menace : $e');
      rethrow;
    }
  }

  // ==================== Gestion des anticorps ====================

  /// Sauvegarde un anticorps.
  Future<void> saveAntibody(String userId, AntibodyModel antibody) async {
    try {
      await _boxOperation<void>(_antibodiesBoxName, userId, (box, key) async {
        final antibodies = (box.get(key) as List<AntibodyModel>?) ?? [];
        antibodies.add(antibody);
        await box.put(key, antibodies);
        AppLogger.info('Anticorps sauvegardé pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde d\'un anticorps : $e');
      rethrow;
    }
  }

  /// Récupère les anticorps d'un utilisateur.
  Future<List<AntibodyModel>?> getAntibodies(String userId) async {
    try {
      return await _boxOperation<List<AntibodyModel>>(
        _antibodiesBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<AntibodyModel>?) ?? [];
        },
        defaultValue: <AntibodyModel>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des anticorps : $e');
      rethrow;
    }
  }

  /// Supprime un anticorps.
  Future<void> removeAntibody(String userId, String antibodyId) async {
    try {
      await _boxOperation<void>(_antibodiesBoxName, userId, (box, key) async {
        final antibodies = (box.get(key) as List<AntibodyModel>?) ?? [];
        antibodies.removeWhere((antibody) => antibody.id == antibodyId);
        await box.put(key, antibodies);
        AppLogger.info(
          'Anticorps supprimé : $antibodyId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression d\'un anticorps : $e');
      rethrow;
    }
  }

  /// Récupère un anticorps spécifique d'un utilisateur.
  Future<AntibodyModel?> getAntibody(String userId, String antibodyId) async {
    try {
      return await _boxOperation<AntibodyModel?>(_antibodiesBoxName, userId, (
        box,
        key,
      ) async {
        final antibodies = (box.get(key) as List<AntibodyModel>?) ?? [];
        try {
          final antibody = antibodies.firstWhere(
            (antibody) => antibody.id == antibodyId,
          );
          return antibody;
        } catch (e) {
          return null; // Gestion de l'absence d'élément
        }
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération d\'un anticorps : $e');
      rethrow;
    }
  }

  /// Récupère les anticorps d'un utilisateur par type.
  Future<List<AntibodyModel>?> getAntibodiesByType(
    String userId,
    String type,
  ) async {
    try {
      return await _boxOperation<List<AntibodyModel>>(
        _antibodiesBoxName,
        userId,
        (box, key) async {
          final antibodies = (box.get(key) as List<AntibodyModel>?) ?? [];
          final filteredAntibodies =
              antibodies
                  .where(
                    (antibody) =>
                        antibody.type.toString().split('.').last == type,
                  )
                  .toList();
          return filteredAntibodies;
        },
        defaultValue: <AntibodyModel>[],
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des anticorps par type : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des pathogènes ====================

  /// Sauvegarde les pathogènes de l'utilisateur.
  Future<void> savePathogens(
    String userId,
    List<PathogenModel> pathogens,
  ) async {
    try {
      await _boxOperation<void>(_pathogensBoxName, userId, (box, key) async {
        await box.put(key, pathogens);
        AppLogger.info(
          'Pathogènes sauvegardés pour l\'utilisateur : $userId, ${pathogens.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde des pathogènes : $e');
      rethrow;
    }
  }

  /// Sauvegarde un pathogène.
  Future<void> savePathogen(String userId, PathogenModel pathogen) async {
    try {
      await _boxOperation<void>(_pathogensBoxName, userId, (box, key) async {
        final pathogens = (box.get(key) as List<PathogenModel>?) ?? [];
        pathogens.add(pathogen);
        await box.put(key, pathogens);
        AppLogger.info('Pathogène sauvegardé pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde d\'un pathogène : $e');
      rethrow;
    }
  }

  /// Récupère les pathogènes d'un utilisateur.
  Future<List<PathogenModel>?> getPathogens(String userId) async {
    try {
      return await _boxOperation<List<PathogenModel>>(
        _pathogensBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<PathogenModel>?) ?? [];
        },
        defaultValue: <PathogenModel>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération des pathogènes : $e');
      rethrow;
    }
  }

  /// Supprime un pathogène.
  Future<void> removePathogen(String userId, String pathogenId) async {
    try {
      await _boxOperation<void>(_pathogensBoxName, userId, (box, key) async {
        final pathogens = (box.get(key) as List<PathogenModel>?) ?? [];
        pathogens.removeWhere((pathogen) => pathogen.id == pathogenId);
        await box.put(key, pathogens);
        AppLogger.info(
          'Pathogène supprimé : $pathogenId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression d\'un pathogène : $e');
      rethrow;
    }
  }

  // ==================== Gestion du classement ====================

  /// Sauvegarde les données du classement.
  Future<void> saveLeaderboard(
    String userId,
    LeaderboardModel leaderboard,
  ) async {
    try {
      await _boxOperation<void>(_leaderboardBoxName, userId, (box, key) async {
        final leaderboards = (box.get(key) as List<LeaderboardModel>?) ?? [];
        leaderboards.add(leaderboard);
        await box.put(key, leaderboards);
        AppLogger.info('Classement sauvegardé pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde du classement : $e');
      rethrow;
    }
  }

  /// Récupère les données du classement d'un utilisateur.
  Future<List<LeaderboardModel>?> getLeaderboard(String userId) async {
    try {
      return await _boxOperation<List<LeaderboardModel>>(
        _leaderboardBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<LeaderboardModel>?) ?? [];
        },
        defaultValue: <LeaderboardModel>[],
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération du classement : $e');
      rethrow;
    }
  }

  /// Supprime les données du classement.
  Future<void> clearLeaderboard(String userId) async {
    try {
      await _boxOperation<void>(_leaderboardBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info('Classement supprimé pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression du classement : $e');
      rethrow;
    }
  }

  // ==================== Gestion des sessions multijoueurs ====================

  /// Sauvegarde une session multijoueur.
  Future<void> saveMultiplayerSession(
    String userId,
    MultiplayerSessionModel session,
  ) async {
    try {
      await _boxOperation<void>(_multiplayerBoxName, userId, (box, key) async {
        final sessions = (box.get(key) as List<MultiplayerSessionModel>?) ?? [];
        sessions.add(session);
        await box.put(key, sessions);
        AppLogger.info(
          'Session multijoueur sauvegardée pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde d\'une session multijoueur : $e',
      );
      rethrow;
    }
  }

  /// Sauvegarde les sessions multijoueurs de l'utilisateur.
  Future<void> saveMultiplayerSessions(
    String userId,
    List<MultiplayerSessionModel> sessions,
  ) async {
    try {
      await _boxOperation<void>(_multiplayerBoxName, userId, (box, key) async {
        await box.put(key, sessions);
        AppLogger.info(
          'Sessions multijoueurs sauvegardées pour l\'utilisateur : $userId, ${sessions.length} éléments',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde des sessions multijoueurs : $e',
      );
      rethrow;
    }
  }

  /// Récupère les sessions multijoueurs d'un utilisateur.
  Future<List<MultiplayerSessionModel>?> getMultiplayerSessions(
    String userId,
  ) async {
    try {
      return await _boxOperation<List<MultiplayerSessionModel>>(
        _multiplayerBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<MultiplayerSessionModel>?) ?? [];
        },
        defaultValue: <MultiplayerSessionModel>[],
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des sessions multijoueurs : $e',
      );
      rethrow;
    }
  }

  /// Supprime une session multijoueur.
  Future<void> removeMultiplayerSession(String userId, String sessionId) async {
    try {
      await _boxOperation<void>(_multiplayerBoxName, userId, (box, key) async {
        final sessions = (box.get(key) as List<MultiplayerSessionModel>?) ?? [];
        sessions.removeWhere((session) => session.sessionId == sessionId);
        await box.put(key, sessions);
        AppLogger.info(
          'Session multijoueur supprimée : $sessionId pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression d\'une session multijoueur : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion de la file d'attente de synchronisation ====================

  /// Ajoute une opération à la file d'attente de synchronisation.
  Future<void> queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    try {
      await _boxOperation<void>(_syncQueueBoxName, userId, (box, key) async {
        final queue = (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        queue.add(operation);
        await box.put(key, queue);
        AppLogger.info(
          'Opération de synchronisation ajoutée à la file pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de l\'ajout à la file de synchronisation : $e',
      );
      rethrow;
    }
  }

  /// Récupère la file d'attente de synchronisation.
  Future<List<Map<String, dynamic>>?> getSyncQueue(String userId) async {
    try {
      return await _boxOperation<List<Map<String, dynamic>>>(
        _syncQueueBoxName,
        userId,
        (box, key) async {
          return (box.get(key) as List<Map<String, dynamic>>?) ?? [];
        },
        defaultValue: <Map<String, dynamic>>[],
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération de la file de synchronisation : $e',
      );
      rethrow;
    }
  }

  /// Supprime une opération de la file d'attente de synchronisation.
  Future<void> clearSyncQueue(String userId) async {
    try {
      await _boxOperation<void>(_syncQueueBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info(
          'File d\'attente de synchronisation supprimée pour l\'utilisateur : $userId',
        );
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression de la file de synchronisation : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des sessions ====================

  /// Sauvegarde une session utilisateur.
  Future<void> saveSession(
    String userId,
    String token,
    DateTime expiryTime,
  ) async {
    try {
      await _boxOperation<void>(_sessionBoxName, userId, (box, key) async {
        final session = CachedSession(
          userId: userId,
          token: token,
          expiryTime: expiryTime,
        );
        await box.put(key, session);
        AppLogger.info('Session sauvegardée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la sauvegarde de la session : $e');
      rethrow;
    }
  }

  /// Récupère une session utilisateur.
  Future<CachedSession?> getSession(String userId) async {
    try {
      return await _boxOperation<CachedSession?>(_sessionBoxName, userId, (
        box,
        key,
      ) async {
        return box.get(key) as CachedSession?;
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de la session : $e');
      rethrow;
    }
  }

  /// Supprime une session utilisateur.
  Future<void> clearSession(String userId) async {
    try {
      await _boxOperation<void>(_sessionBoxName, userId, (box, key) async {
        await box.delete(key);
        AppLogger.info('Session supprimée pour l\'utilisateur : $userId');
      });
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression de la session : $e');
      rethrow;
    }
  }

  /// Vérifie la validité d'une session.
  Future<bool> checkSessionValidity(String userId) async {
    try {
      final session = await getSession(userId);
      final isValid = session?.isValid ?? false;
      AppLogger.info(
        'Validité de la session pour l\'utilisateur $userId : $isValid',
      );
      return isValid;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la vérification de la validité de la session : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion de l'utilisateur courant ====================

  /// Sauvegarde l'utilisateur courant.
  Future<void> saveCurrentUser(String userId, UserEntity user) async {
    try {
      await _boxOperation<void>(_currentUserCacheBoxName, userId, (
        box,
        key,
      ) async {
        await box.put(key, user);
        AppLogger.info('Utilisateur courant sauvegardé : $userId');
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde de l\'utilisateur courant : $e',
      );
      rethrow;
    }
  }

  /// Récupère l'utilisateur courant.
  UserEntity? getCurrentUserCache(String userId) {
    try {
      return _boxOperation<UserEntity?>(_currentUserCacheBoxName, userId, (
            box,
            key,
          ) async {
            return box.get(key) as UserEntity?;
          })
          as UserEntity?;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération de l\'utilisateur courant : $e',
      );
      rethrow;
    }
  }

  /// Supprime l'utilisateur courant.
  Future<void> clearCurrentUser(String userId) async {
    try {
      await _boxOperation<void>(_currentUserCacheBoxName, userId, (
        box,
        key,
      ) async {
        await box.delete(key);
        AppLogger.info('Utilisateur courant supprimé : $userId');
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression de l\'utilisateur courant : $e',
      );
      rethrow;
    }
  }

  // ==================== Gestion des réponses de Gemini AI ====================

  /// Sauvegarde une réponse de Gemini AI.
  Future<void> saveGeminiResponse(
    String userId,
    GeminiResponse response,
  ) async {
    try {
      final userKey = '$userId-${response.id}';
      await _boxOperation<void>(_geminiBoxName, userKey, (box, key) async {
        await box.put(key, response);
        AppLogger.info('Réponse Gemini sauvegardée : $userKey');
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la sauvegarde d\'une réponse Gemini : $e',
      );
      rethrow;
    }
  }

  /// Récupère une réponse spécifique de Gemini AI.
  Future<GeminiResponse?> getGeminiResponse(
    String userId,
    String responseId,
  ) async {
    try {
      final userKey = '$userId-$responseId';
      return await _boxOperation<GeminiResponse?>(_geminiBoxName, userKey, (
        box,
        key,
      ) async {
        return box.get(key) as GeminiResponse?;
      });
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération d\'une réponse Gemini : $e',
      );
      rethrow;
    }
  }

  /// Récupère toutes les réponses de Gemini AI d'un utilisateur.
  Future<List<GeminiResponse>> getAllGeminiResponses(String userId) async {
    try {
      final box = Hive.box(_geminiBoxName);
      final responses = <GeminiResponse>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          final response = box.get(key);
          if (response is GeminiResponse) {
            responses.add(response);
          }
        }
      }
      AppLogger.info(
        'Récupération de toutes les réponses Gemini pour l\'utilisateur : $userId',
      );
      return responses;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des réponses Gemini : $e',
      );
      rethrow;
    }
  }

  /// Récupère l'historique des chats Gemini d'un utilisateur.
  Future<List<GeminiResponse>> getGeminiChatHistory(String userId) async {
    try {
      final box = Hive.box(_geminiBoxName);
      final chats = <GeminiResponse>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          final response = box.get(key);
          if (response is GeminiResponse && response.type == 'chat') {
            chats.add(response);
          }
        }
      }
      AppLogger.info(
        'Récupération de l\'historique des chats Gemini pour l\'utilisateur : $userId',
      );
      return chats;
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération de l\'historique des chats Gemini : $e',
      );
      rethrow;
    }
  }

  /// Supprime toutes les réponses Gemini d'un utilisateur.
  Future<void> clearGeminiResponses(String userId) async {
    try {
      final box = Hive.box(_geminiBoxName);
      final keysToRemove = <dynamic>[];
      for (var key in box.keys) {
        if (key.toString().startsWith('$userId-')) {
          keysToRemove.add(key);
        }
      }
      await box.deleteAll(keysToRemove);
      AppLogger.info(
        'Réponses Gemini supprimées pour l\'utilisateur : $userId',
      );
    } catch (e) {
      AppLogger.error('Erreur lors de la suppression des réponses Gemini : $e');
      rethrow;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/data/models/combat/pathogen_model.dart';
import 'package:immuno_warriors/data/models/combat/antibody_model.dart';
import 'package:immuno_warriors/data/models/research_model.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/data/models/api/gemini_response.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/data/models/cached_session.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';

/// Provides local storage services using Hive.
class LocalStorageService {
  // Static fields for box names
  static const String _userBoxName = 'user';
  static const String _memoryBoxName = 'memory';
  static const String _combatBoxName = 'combat';
  static const String _researchBoxName = 'research';
  static const String _geminiBoxName = 'gemini';
  static const String _combatReportBoxName = 'combatReports';
  static const String _basViralesBoxName = 'baseVirales';
  static const String _usersCacheBoxName = 'usersCache';
  static const String _currentUserCacheBoxName = 'currentUserCache';
  static const String _sessionBoxName = 'session';
  static const String _generalDataBoxName = 'generalData';

  // Private constructor for singleton pattern
  LocalStorageService._internal();

  // Static instance
  static final LocalStorageService _instance = LocalStorageService._internal();

  // Factory constructor to return the singleton instance
  factory LocalStorageService() {
    return _instance;
  }

  // Static method to initialize Hive
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    // Register adapters here
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(PathogenModelAdapter());
    Hive.registerAdapter(AntibodyModelAdapter());
    Hive.registerAdapter(ResearchModelAdapter());
    Hive.registerAdapter(GeminiResponseAdapter());
    Hive.registerAdapter(CombatReportModelAdapter());
    Hive.registerAdapter(BaseViraleModelAdapter());
    Hive.registerAdapter(CachedSessionAdapter());
    Hive.registerAdapter(UserModelAdapter());

    await _openBoxes();
  }

  // Static method to open boxes
  static Future<void> _openBoxes() async {
    try {
      await Hive.openBox<UserModel>(_userBoxName);
      await Hive.openBox<String>(_memoryBoxName);
      await Hive.openBox(_combatBoxName);
      await Hive.openBox(_researchBoxName);
      await Hive.openBox<GeminiResponse>(_geminiBoxName);
      await Hive.openBox<CombatReportModel>(_combatReportBoxName);
      await Hive.openBox<BaseViraleModel>(_basViralesBoxName);
      await Hive.openBox<List<UserEntity>>(_usersCacheBoxName);
      await Hive.openBox<UserEntity>(_currentUserCacheBoxName);
      await Hive.openBox<CachedSession>(_sessionBoxName);
      await Hive.openBox(_generalDataBoxName); // Open the new general data box
      AppLogger.info('Hive boxes opened successfully.');
    } catch (e) {
      AppLogger.error('Failed to open Hive boxes: $e');
      throw Exception(AppStrings.hiveInitializationFailed);
    }
  }

  // Generic helper method
  Future<T?> _boxOperation<T>(
      String boxName, String key, Future<T> Function(Box box, String key) operation,
      {T? defaultValue}) async {
    try {
      final box = Hive.box(boxName);
      if (!box.containsKey(key) && defaultValue != null) {
        return defaultValue;
      }
      return await operation(box, key);
    } catch (e) {
      AppLogger.error('Error in box $boxName operation with key $key: $e');
      rethrow;
    }
  }

  // ==================== General Data (New) ====================
  /// Saves general data (not specific to a user) to local storage.
  Future<void> saveData(String key, dynamic value) async {
    try {
      final box = Hive.box(_generalDataBoxName);
      await box.put(key, value);
    } catch (e) {
      AppLogger.error('Error saving data with key $key: $e');
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }

  /// Retrieves general data from local storage.
  /// Returns null if the key does not exist.
  dynamic getData(String key) {
    try {
      final box = Hive.box(_generalDataBoxName);
      return box.get(key);
    } catch (e) {
      AppLogger.error('Error getting data with key $key: $e');
      rethrow;
    }
  }

  /// Clears general data from local storage.
  Future<void> clearData(String key) async {
    try {
      final box = Hive.box(_generalDataBoxName);
      await box.delete(key);
    } catch (e) {
      AppLogger.error('Error clearing data with key $key: $e');
      rethrow;
    }
  }

  // ==================== User Data ====================
  Future<void> saveUser(UserModel user) async {
    await _boxOperation<void>(_userBoxName, user.id, (box, key) async {
      await box.put(key, user);
    });
  }

  UserModel? getUser(String userId) {
    return _boxOperation<UserModel?>(_userBoxName, userId, (box, key) async {
      return box.get(key);
    }) as UserModel?;
  }

  Future<void> clearUser(String userId) async {
    await _boxOperation<void>(_userBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  // ==================== Pathogen Signatures ====================
  Future<void> savePathogenSignature(String userId, String signature) async {
    await _boxOperation<void>(_memoryBoxName, userId, (box, key) async {
      final List<String> signatures =
          (box.get(key) as List<String>?) ?? [];
      signatures.add(signature);
      await box.put(
          key, signatures);
    });
  }

  Future<List<String>?> getPathogenSignatures(String userId) async {
    return await _boxOperation<List<String>?>(_memoryBoxName, userId, (box, key) async {
      return (box.get(key) as List<String>?) ??
          [];
    }, defaultValue: <String>[]);
  }

  Future<void> clearPathogenSignatures(String userId) async {
    await _boxOperation<void>(_memoryBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  // ==================== Research Progress ====================
  Future<void> saveResearchProgress(
      String userId, Map<String, dynamic> progress) async {
    await _boxOperation<void>(_researchBoxName, userId, (box, key) async {
      await box.put(key, progress);
    });
  }

  Map<String, dynamic>? getResearchProgress(String userId) {
    return _boxOperation<Map<String, dynamic>?>(_researchBoxName, userId,
            (box, key) async {
          return box.get(key);
        }) as Map<String, dynamic>?;
  }

  Future<void> clearResearchProgress(String userId) async {
    await _boxOperation<void>(_researchBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  // ==================== Combat Data ====================
  Future<void> saveCombatData(String userId, dynamic combatData) async {
    await _boxOperation<void>(_combatBoxName, userId, (box, key) async {
      final List<dynamic> combatDataList = (box.get(key) ?? []);
      combatDataList.add(combatData);
      await box.put(key, combatDataList);
    });
  }

  Future<List?> getCombatData(String userId) {
    return _boxOperation<List<dynamic>>(_combatBoxName, userId, (box, key) async {
      return box.get(key) ?? [];
    }, defaultValue: <dynamic>[]);
  }

  Future<void> clearCombatData(String userId) async {
    await _boxOperation<void>(_combatBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  // ==================== Gemini Responses ====================
  Future<void> saveGeminiResponse(String userId, GeminiResponse response) async {
    await _boxOperation<void>(_geminiBoxName, userId, (box, key) async {
      final List<GeminiResponse> responses =
          (box.get(key) as List<GeminiResponse>?) ?? [];
      responses.add(response);
      await box.put(key, responses);
    });
  }

  Future<List<GeminiResponse>?> getGeminiResponses(String userId) {
    return _boxOperation<List<GeminiResponse>>(_geminiBoxName, userId,
            (box, key) async {
          return (box.get(key) as List<GeminiResponse>?) ?? [];
        }, defaultValue: <GeminiResponse>[]);
  }

  Future<void> clearGeminiResponses(String userId) async {
    await _boxOperation<void>(_geminiBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  // ==================== Combat Reports ====================
  Future<void> saveCombatReport(String userId, CombatReportModel report) async {
    final String userKey = '$userId-${report.combatId}'; // Combine userId and combatId
    try {
      final box = Hive.box(_combatReportBoxName);
      await box.put(userKey, report); // Use the combined key
    } catch (e) {
      AppLogger.error('Error saving combat report: $e');
      rethrow;
    }
  }

  CombatReportModel? getCombatReport(String userId, String combatId) {
    final String userKey = '$userId-$combatId';
    try {
      final box = Hive.box(_combatReportBoxName);
      return box.get(userKey);
    } catch (e) {
      AppLogger.error('Error getting combat report: $e');
      return null; // Important: Handle the error and return null
    }
  }


  Future<List<CombatReportModel>?> getAllCombatReportsLocal(String userId) async {
    try{
      final box = Hive.box(_combatReportBoxName);
      final reports = <CombatReportModel>[];
      for(var key in box.keys){
        if(key.toString().startsWith('$userId-')){
          final report = box.get(key);
          if(report is CombatReportModel){
            reports.add(report);
          }
        }
      }
      return reports;
    }catch(e){
      AppLogger.error('Error getting all combat reports: $e');
      return null;
    }
  }

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
    } catch (e) {
      AppLogger.error('Error clearing combat reports: $e');
      rethrow;
    }
  }

  // ==================== Cached Users ====================
  Future<void> cacheUsers(String userId, List<UserEntity> users) async {
    await _boxOperation<void>(_usersCacheBoxName, userId, (box, key) async {
      await box.put(key, users);
    });
  }

  Future<List<UserEntity>?> getUsers(String userId) async {
    return _boxOperation<List<UserEntity>?>(_usersCacheBoxName, userId,
            (box, key) async {
          return box.get(key) as List<UserEntity>?;
        }, defaultValue: <UserEntity>[]);
  }

  Future<UserEntity?> getUserById(String currentUserId, String userIdToFind) async {
    try {
      final box = Hive.box(_usersCacheBoxName);
      final cachedUsers = box.get(currentUserId) as List<UserEntity>?;
      if (cachedUsers == null) return null;
      for (var user in cachedUsers) {
        if (user.id == userIdToFind) {
          return user;
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting user by ID: $e');
      return null;
    }
  }

  // ==================== Cached Session ====================
  Future<void> saveSession(
      String userId, String token, DateTime expiryTime) async {
    await _boxOperation<void>(_sessionBoxName, userId, (box, key) async {
      final session =
      CachedSession(userId: userId, token: token, expiryTime: expiryTime);
      await box.put(key, session);
    });
  }

  Future<CachedSession?> getSession(String userId) async {
    return _boxOperation<CachedSession?>(_sessionBoxName, userId, (box, key) async {
      return box.get(key);
    }) as CachedSession?;
  }

  Future<void> clearSession(String userId) async {
    await _boxOperation<void>(_sessionBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }

  Future<bool> checkSessionValidity(String userId) async {
    final session = await getSession(userId);
    return session?.isValid ?? false;
  }

  // ==================== Cached Current User ====================
  Future<void> saveCurrentUser(String userId, UserEntity user) async {
    await _boxOperation<void>(_currentUserCacheBoxName, userId, (box, key) async {
      await box.put(key, user);
    });
  }

  UserEntity? getCurrentUserCache(String userId) {
    return _boxOperation<UserEntity?>(_currentUserCacheBoxName, userId,
            (box, key) async {
          return box.get(key);
        }) as UserEntity?;
  }

  Future<void> clearCurrentUser(String userId) async {
    await _boxOperation<void>(_currentUserCacheBoxName, userId, (box, key) async {
      await box.delete(key);
    });
  }
}


import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/data/models/combat/pathogen_model.dart';
import 'package:immuno_warriors/data/models/combat/antibody_model.dart';
import 'package:immuno_warriors/data/models/research_model.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart'; // Import CombatReportModel

import '../../data/models/api/gemini_response.dart';
import '../../data/models/base_viral_model.dart';

/// Provides local storage services using Hive.
class LocalStorageService {
  static const String _userBoxName = 'user';
  static const String _memoryBoxName = 'memory';
  static const String _combatBoxName = 'combat';
  static const String _researchBoxName = 'research';
  static const String _geminiBoxName = 'gemini';
  static const String _combatReportBoxName = 'combatReports';
  static const String _basViralesBoxName = 'baseVirales';

  /// Initializes Hive.  Call this once in your main() function.
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
    Hive.registerAdapter(BaseViraleModelAdapter()); // Adapter généré par Hive

    // Register CombatReportModelAdapter
    await _openBoxes();
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<UserModel>(_userBoxName);
    await Hive.openBox<String>(_memoryBoxName); // For pathogen signatures
    await Hive.openBox(_combatBoxName); // For recent combat data (keeping this for potential other combat-related data)
    await Hive.openBox(_researchBoxName); // For research progress
    await Hive.openBox<GeminiResponse>(_geminiBoxName);
    await Hive.openBox<CombatReportModel>(_combatReportBoxName); // Open box for combat reports
    await Hive.openBox<BaseViraleModel>(_basViralesBoxName);
  }

  /// Saves the user data locally.
  Future<void> saveUser(UserModel user) async {
    try {
      final box = Hive.box<UserModel>(_userBoxName);
      await box.put('currentUser', user);
    } catch (e) {
      AppLogger.log('Error saving user data: $e');
      rethrow;
    }
  }

  /// Retrieves the user data from local storage.
  UserModel? getUser() {
    try {
      final box = Hive.box<UserModel>(_userBoxName);
      return box.get('currentUser');
    } catch (e) {
      AppLogger.log('Error getting user data: $e');
      return null;
    }
  }

  /// Clears the user data from local storage.
  Future<void> clearUser() async {
    try {
      final box = Hive.box<UserModel>(_userBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing user data: $e');
      rethrow;
    }
  }

  /// Stores a pathogen signature in the MemoireImmunitaire.
  Future<void> savePathogenSignature(String signature) async {
    try {
      final box = Hive.box<String>(_memoryBoxName);
      await box.add(signature);
    } catch (e) {
      AppLogger.log('Error saving pathogen signature: $e');
      rethrow;
    }
  }

  /// Retrieves all stored pathogen signatures.
  List<String> getPathogenSignatures() {
    try {
      final box = Hive.box<String>(_memoryBoxName);
      return box.values.toList();
    } catch (e) {
      AppLogger.log('Error getting pathogen signatures: $e');
      return [];
    }
  }

  /// Clears all stored pathogen signatures.
  Future<void> clearPathogenSignatures() async {
    try {
      final box = Hive.box<String>(_memoryBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing pathogen signatures: $e');
      rethrow;
    }
  }

  /// Saves recent combat data.
  Future<void> saveCombatData(dynamic combatData) async {
    try {
      final box = Hive.box(_combatBoxName);
      await box.add(combatData); // Adjust key/value logic as needed
    } catch (e) {
      AppLogger.log('Error saving combat data: $e');
      rethrow;
    }
  }

  /// Retrieves recent combat data.
  List<dynamic> getCombatData() {
    try {
      final box = Hive.box(_combatBoxName);
      return box.values.toList();
    } catch (e) {
      AppLogger.log('Error getting combat data: $e');
      return [];
    }
  }

  /// Clears recent combat data.
  Future<void> clearCombatData() async {
    try {
      final box = Hive.box(_combatBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing combat data: $e');
      rethrow;
    }
  }

  /// Saves research progress.
  Future<void> saveResearchProgress(Map<String, dynamic> progress) async {
    try {
      final box = Hive.box(_researchBoxName);
      await box.put('progress', progress);
    } catch (e) {
      AppLogger.log('Error saving research progress: $e');
      rethrow;
    }
  }

  /// Retrieves research progress.
  Map<String, dynamic>? getResearchProgress() {
    try {
      final box = Hive.box(_researchBoxName);
      return box.get('progress');
    } catch (e) {
      AppLogger.log('Error getting research progress: $e');
      return null;
    }
  }

  /// Clears research progress.
  Future<void> clearResearchProgress() async {
    try {
      final box = Hive.box(_researchBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing research progress: $e');
      rethrow;
    }
  }

  /// Saves a Gemini response locally.
  Future<void> saveGeminiResponse(GeminiResponse response) async {
    try {
      final box = Hive.box<GeminiResponse>(_geminiBoxName);
      await box.add(response); // Utilise add() pour ajouter une nouvelle réponse
    } catch (e) {
      AppLogger.log('Error saving Gemini response: $e');
      rethrow;
    }
  }

  /// Retrieves all stored Gemini responses.
  List<GeminiResponse> getGeminiResponses() {
    try {
      final box = Hive.box<GeminiResponse>(_geminiBoxName);
      return box.values.toList();
    } catch (e) {
      AppLogger.log('Error getting Gemini responses: $e');
      return [];
    }
  }

  /// Clears all stored Gemini responses.
  Future<void> clearGeminiResponses() async {
    try {
      final box = Hive.box<GeminiResponse>(_geminiBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing Gemini responses: $e');
      rethrow;
    }
  }

  /// Saves a combat report locally.
  Future<void> saveCombatReport(CombatReportModel report) async {
    try {
      final box = Hive.box<CombatReportModel>(_combatReportBoxName);
      await box.put(report.combatId, report);
    } catch (e) {
      AppLogger.log('Error saving combat report: $e');
      rethrow;
    }
  }

  /// Retrieves a combat report by its ID.
  CombatReportModel? getCombatReport(String combatId) {
    try {
      final box = Hive.box<CombatReportModel>(_combatReportBoxName);
      return box.get(combatId);
    } catch (e) {
      AppLogger.log('Error getting combat report: $e');
      return null;
    }
  }

  /// Retrieves all combat reports.
  List<CombatReportModel> getAllCombatReportsLocal() {
    try {
      final box = Hive.box<CombatReportModel>(_combatReportBoxName);
      return box.values.toList();
    } catch (e) {
      AppLogger.log('Error getting all combat reports: $e');
      return [];
    }
  }

  /// Clears all stored combat reports.
  Future<void> clearCombatReports() async {
    try {
      final box = Hive.box<CombatReportModel>(_combatReportBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.log('Error clearing combat reports: $e');
      rethrow;
    }
  }
}
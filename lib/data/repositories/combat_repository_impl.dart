import 'package:immuno_warriors/domain/repositories/combat_repository.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:immuno_warriors/data/datasources/local/combat_local_datasource.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/services/combat_service.dart';
import 'package:immuno_warriors/core/services/mutation_service.dart';
import 'package:immuno_warriors/core/services/gemini_service.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

class CombatRepositoryImpl implements CombatRepository {
  final GeminiRemoteDataSource _geminiRemoteDataSource;
  final CombatLocalDataSource _combatLocalDataSource;
  final CombatService _combatService = CombatService();
  final MutationService _mutationService = MutationService();
  final GeminiService _geminiService = GeminiService(); // Instance du service Gemini
  final Uuid _uuid = Uuid();

  CombatRepositoryImpl({
    required GeminiRemoteDataSource geminiRemoteDataSource,
    required CombatLocalDataSource combatLocalDataSource,
  })  : _geminiRemoteDataSource = geminiRemoteDataSource,
        _combatLocalDataSource = combatLocalDataSource;

  @override
  Future<CombatReportModel> simulateCombat({
    required List<AntibodyEntity> antibodies,
    required List<PathogenEntity> pathogens,
    required String baseId,
  }) async {
    final mutatedPathogens = pathogens.map((pathogen) => _mutationService.applyMutation(pathogen)).toList();

    final combatResult = _combatService.simulateCombat(
      antibodies: antibodies,
      pathogens: mutatedPathogens,
    );

    final bool playerVictory = combatResult['result'] == 'Antibodies Win';
    final List<String> combatLog = List<String>.from(combatResult['log']);
    final List<Map<String, dynamic>> survivingAntibodiesJson =
    List<Map<String, dynamic>>.from(combatResult['surviving_antibodies']);
    final List<Map<String, dynamic>> survivingPathogensJson =
    List<Map<String, dynamic>>.from(combatResult['surviving_pathogens']);

    final int damageDealt = _calculateDamageDealtFromLog(combatLog, antibodies);
    final int damageTaken = _calculateDamageTakenFromLog(combatLog, mutatedPathogens);

    final List<String> unitsLost =
    _getLostUnits(antibodies, pathogens, survivingAntibodiesJson);

    final combatReportModel = CombatReportModel(
      combatId: _uuid.v4(),
      date: DateTime.now(),
      result: playerVictory ? 'Victory' : 'Defeat',
      log: combatLog,
      damageDealt: damageDealt,
      damageTaken: damageTaken,
      unitsDeployed: antibodies.map((e) => e.id).toList(),
      unitsLost: unitsLost,
      baseId: baseId,
      antibodiesUsed: List.from(antibodies),
      pathogenFought: mutatedPathogens.isNotEmpty ? mutatedPathogens.first : null,
    );

    await saveCombatResult(combatReportModel);

    // Générer un conseil tactique après le combat (exemple)
    final gameState = 'Player ${playerVictory ? 'won' : 'lost'} the combat.';
    final enemyBaseInfo = 'Fought against ${pathogens.length} pathogens.';
    try {
      final tacticalAdvice = await _geminiService.getTacticalAdvice(gameState, enemyBaseInfo);
      AppLogger.info('Tactical Advice: $tacticalAdvice');
      // Ici, tu peux choisir d'inclure le conseil dans le CombatReportModel
      // ou de le rendre disponible via une autre méthode.
    } catch (e) {
      AppLogger.error('Error getting tactical advice: $e');
    }

    return combatReportModel;
  }

  int _calculateDamageDealtFromLog(
      List<String> log, List<AntibodyEntity> antibodies) {
    int totalDamage = 0;
    for (final line in log) {
      for (final antibody in antibodies) {
        if (line.contains('${antibody.name} attacks')) {
          final match = RegExp(r'for (\d+) damage').firstMatch(line);
          if (match != null && match.group(1) != null) {
            totalDamage += int.parse(match.group(1)!);
          }
        }
      }
    }
    return totalDamage;
  }

  int _calculateDamageTakenFromLog(
      List<String> log, List<PathogenEntity> pathogens) {
    int totalDamage = 0;
    for (final line in log) {
      for (final pathogen in pathogens) {
        if (line.contains('${pathogen.name} attacks')) {
          final match = RegExp(r'for (\d+) damage').firstMatch(line);
          if (match != null && match.group(1) != null) {
            totalDamage += int.parse(match.group(1)!);
          }
        }
      }
    }
    return totalDamage;
  }

  List<String> _getLostUnits(
      List<AntibodyEntity> initialAntibodies,
      List<PathogenEntity> initialPathogens,
      List<Map<String, dynamic>> survivingAntibodiesJson) {
    final survivingAntibodyIds =
    survivingAntibodiesJson.map((json) => json['id'] as String).toSet();
    return initialAntibodies
        .where((antibody) => !survivingAntibodyIds.contains(antibody.id))
        .map((antibody) => antibody.id)
        .toList();
  }

  @override
  Future<String> generateCombatChronicle(CombatReportModel combatResult) async {
    try {
      final chronicle =
      await _geminiRemoteDataSource.generateCombatChronicle(combatResult);
      return chronicle;
    } catch (e) {
      AppLogger.error('Error generating combat chronicle: $e');
      return 'Combat chronicle could not be generated.';
    }
  }

  @override
  Future<void> saveCombatResult(CombatReportModel combatReport) async {
    try {
      await _combatLocalDataSource.saveCombatResult(combatReport);
    } catch (e) {
      AppLogger.error('Error saving combat result: $e');
      rethrow;
    }
  }

  @override
  Future<List<CombatReportModel>> getCombatHistory() async {
    try {
      return await _combatLocalDataSource.getCombatHistory();
    } catch (e) {
      AppLogger.error('Error getting combat history: $e');
      rethrow;
    }
  }

  /// Récupère un conseil tactique basé sur l'état du jeu et les informations sur l'ennemi.
  /// Ceci est une méthode supplémentaire pour utiliser GeminiService.
  ///
  @override
  Future<String?> getCombatTacticalAdvice({String? gameState, String? enemyBaseInfo}) async {
    if (gameState == null || enemyBaseInfo == null) {
      AppLogger.warning('Game state or enemy base info not provided for tactical advice.');
      return null;
    }
    try {
      return await _geminiService.getTacticalAdvice(gameState, enemyBaseInfo);
    } catch (e) {
      AppLogger.error('Error getting tactical advice: $e');
      return null;
    }
  }
}
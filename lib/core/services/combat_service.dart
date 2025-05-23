
import 'dart:math';
import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';

/// Provides services for simulating combat between antibodies and pathogens.
class CombatService {
  final Random _random = Random();

  /// Simulates a combat encounter between a squad of antibodies and a wave of pathogens.
  ///
  /// Returns a detailed combat report.
  Map<String, dynamic> simulateCombat({
    required List<AntibodyEntity> antibodies,
    required List<PathogenEntity> pathogens,
  }) {
    final combatLog = <String>[];
    var turn = 1;

    // Create copies to avoid modifying the originals
    final activeAntibodies = antibodies.map((a) => a.copyWith()).toList();
    final activePathogens = pathogens.map((p) => p.copyWith()).toList();

    while (activeAntibodies.isNotEmpty &&
        activePathogens.isNotEmpty &&
        turn <= GameConstants.maxCombatTurns) {
      combatLog.add('--- Turn $turn ---');

      _antibodyTurn(activeAntibodies, activePathogens, combatLog);
      _pathogenTurn(activeAntibodies, activePathogens, combatLog);

      // Remove defeated units
      activeAntibodies.removeWhere((antibody) => antibody.health <= 0);
      activePathogens.removeWhere((pathogen) => pathogen.health <= 0);

      turn++;
    }

    final result = activeAntibodies.isNotEmpty
        ? 'Antibodies Win'
        : activePathogens.isNotEmpty
        ? 'Pathogens Win'
        : 'Draw';

    combatLog.add('--- Combat End: $result ---');

    return {
      'result': result,
      'log': combatLog,
      'surviving_antibodies': activeAntibodies.map((a) => a.toJson()).toList(),
      'surviving_pathogens': activePathogens.map((p) => p.toJson()).toList(),
    };
  }

  void _antibodyTurn(List<AntibodyEntity> antibodies,
      List<PathogenEntity> pathogens,
      List<String> combatLog,) {
    for (final antibody in antibodies) {
      if (pathogens.isNotEmpty) {
        final target = _selectTarget(pathogens);
        final damage = antibody.damage;
        final attackType = antibody.attackType;

        double damageMultiplier = _calculateDamageMultiplier(
            attackType, target.resistanceType, target.attackType);
        final totalDamage = (damage * damageMultiplier).round();

        _applyDamage(target, totalDamage);

        combatLog.add(
            '${antibody.name} attacks ${target.name} for $totalDamage damage.');

        _applyAntibodyAbility(antibody, antibodies, pathogens,
            combatLog);
      }
    }
  }

  void _pathogenTurn(List<AntibodyEntity> antibodies,
      List<PathogenEntity> pathogens,
      List<String> combatLog,) {
    for (final pathogen in pathogens) {
      if (antibodies.isNotEmpty) {
        final target = _selectTarget(antibodies);
        final damage = pathogen.attack;
        final attackType = pathogen.attackType;

        double damageMultiplier = _calculateDamageMultiplier(
            attackType, target.resistanceType, target.attackType);
        final totalDamage = (damage * damageMultiplier).round();

        _applyDamage(target, totalDamage);

        combatLog.add(
            '${pathogen.name} attacks ${target.name} for $totalDamage damage.');

        _applyPathogenAbility(pathogen, antibodies, pathogens, combatLog);
      }
    }
  }

  /// Calculates the damage multiplier based on attack and resistance types.
  double _calculateDamageMultiplier(AttackType attackerAttackType,
      ResistanceType targetResistanceType,
      AttackType targetAttackType,) {
    double multiplier = 1.0;

    if (attackerAttackType == targetResistanceType) {
      multiplier = 1.5;
    } else if (attackerAttackType == targetAttackType) {
      multiplier = 0.5;
    }

    return multiplier;
  }

  /// Applies damage to a target and logs the event.
  void _applyDamage(dynamic target, int damage) {
    target.health -= damage;
    if (target.health < 0) {
      target.health = 0;
    }
  }

  /// Selects a target for an attacker (simple AI).
  dynamic _selectTarget(List targets) {
    // Basic: Attack weakest enemy
    targets.sort((a, b) => a.health.compareTo(b.health));
    return targets.isNotEmpty ? targets.first : null;
  }

  /// Applies the special ability of an antibody.
  void _applyAntibodyAbility(AntibodyEntity antibody,
      List<AntibodyEntity> antibodies,
      List<PathogenEntity> pathogens,
      List<String> combatLog,) {
    switch (antibody.type) {
      case AntibodyType.igG:
      // Deal damage to multiple pathogens
        for (final pathogen in pathogens) {
          final damage = (antibody.damage * 0.5).round();
          _applyDamage(pathogen, damage);
          combatLog.add(
              '${antibody.name} uses SalvoToxique, dealing $damage to ${pathogen
                  .name}.');
        }
        break;
      case AntibodyType.igM:
      // Heal itself
        final healAmount = (antibody.damage * 0.2).round();
        antibody.health += healAmount;
        if (antibody.health >
            antibody.maxHealth) { // Correction: utiliser maxHealth
          antibody.health = antibody.maxHealth;
        }
        combatLog
            .add('${antibody.name} uses ReparationCellulaire, healing itself.');
        break;
    // Add more cases for other abilities
      default:
        break;
    }
  }

  /// Applies the special ability of a pathogen.
  void _applyPathogenAbility(PathogenEntity pathogen,
      List<AntibodyEntity> antibodies,
      List<PathogenEntity> pathogens,
      List<String> combatLog,) {
    if (pathogen.abilities == null) return;

    for (final ability in pathogen.abilities!) {
      switch (ability) {
        case 'MutationRapide':
        // Change weakness (randomly)
          final resistanceTypes = ResistanceType
              .values; // Obtient une liste de toutes les valeurs de l'enum ResistanceType
          if (resistanceTypes.isNotEmpty) {
            final newResistanceIndex = _random.nextInt(resistanceTypes.length);
            final newResistance = resistanceTypes[newResistanceIndex];
            pathogen.resistanceType = newResistance;
            combatLog.add(
                '${pathogen
                    .name} uses MutationRapide, changing its weakness to ${newResistance
                    .toString()
                    .split('.')
                    .last}.');
          }
          break;
        case 'BouclierBiofilm':
        // Reduce incoming damage for a turn (simplified)
          combatLog.add(
              '${pathogen
                  .name} uses BouclierBiofilm, reducing incoming damage.');
          break;
      // Add more cases for other abilities
        default:
          break;
      }
    }
  }
}


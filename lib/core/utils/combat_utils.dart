import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart';

/// Provides utility functions for combat-related calculations.
class CombatUtils {
  /// Calculates the damage dealt by an attacker to a defender.
  static double calculateDamage(
      double baseDamage,
      double attackerMultiplier,
      double defenderMultiplier,
      List<String> attackerAttackTypes,
      List<String> defenderWeaknesses,
      List<String> defenderResistances,
      ) {
    double damage = baseDamage * attackerMultiplier;

    for (final attackType in attackerAttackTypes) {
      if (defenderWeaknesses.contains(attackType)) {
        damage *= 1.5; // Example weakness multiplier
      }
      if (defenderResistances.contains(attackType)) {
        damage *= 0.5; // Example resistance multiplier
      }
    }

    return damage;
  }

  /// Applies defense to incoming damage.
  static double applyDefense(double damage, double defenseFactor) {
    return damage * (1 - defenseFactor);
  }

  /// Calculates the attack speed with multipliers.
  static double calculateAttackSpeed(double baseSpeed, double multiplier) {
    return baseSpeed * multiplier;
  }

  /// Calculates the total HP with multipliers.
  static double calculateTotalHp(double baseHp, double multiplier) {
    return baseHp * multiplier;
  }

  /// Calculates the potential damage per turn for a unit.
  static double calculateDps(double damage, double attackSpeed) {
    return damage * attackSpeed;
  }





  static AntibodyEntity applyMemoryBonus(AntibodyEntity antibody, int memoryCount) {
    final bonusMultiplier = 1 + (memoryCount * GameConstants.memoryBonusPerSignature);
    return antibody.copyWith(
      damage: (antibody.damage * bonusMultiplier).toInt(),
      range: (antibody.range * bonusMultiplier).toInt(),
      efficiency: antibody.efficiency + (memoryCount * 0.05),
    );
  }



}
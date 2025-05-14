import 'dart:math';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';

/// Provides services for handling pathogen mutations.
class MutationService {
  final Random _random = Random();

  /// Applies a mutation to a pathogen.
  ///
  /// Returns the mutated PathogenEntity or the original if no mutation occurs.
  PathogenEntity applyMutation(PathogenEntity pathogen) {
    try {
      if (_shouldMutate(pathogen)) {
        return _mutatePathogen(pathogen);
      }
      return pathogen;
    } catch (e) {
      AppLogger.log('Error applying mutation: $e');
      rethrow;
    }
  }

  /// Determines if a pathogen should mutate.
  bool _shouldMutate(PathogenEntity pathogen) {
    // Exemple: Chance basée sur le taux de mutation du pathogène
    final mutationChance = pathogen.mutationRate;
    return _random.nextDouble() < mutationChance;
  }

  /// Mutates the pathogen.
  PathogenEntity _mutatePathogen(PathogenEntity pathogen) {
    final mutationType = _selectMutationType();
    switch (mutationType) {
      case 'attack': // Correction du nom pour correspondre à la propriété
        return _increaseAttack(pathogen);
      case 'health': // Correction du nom pour correspondre à la propriété
        return _increaseHealth(pathogen);
    // 'speed' n'est pas une propriété directe de PathogenEntity
    // case 'speed':
    //   return _increaseSpeed(pathogen);
      case 'resistance':
        return _increaseResistance(pathogen);
      default:
        return pathogen;
    }
  }

  /// Sélectionne un type de mutation aléatoire.
  String _selectMutationType() {
    const mutations = ['attack', 'health', 'resistance'];
    final index = _random.nextInt(mutations.length);
    return mutations[index];
  }

  /// Augmente l'attaque du pathogène.
  PathogenEntity _increaseAttack(PathogenEntity pathogen) {
    final newAttack =
    (pathogen.attack * GameConstants.mutationDamageMultiplier).round();
    return pathogen.copyWith(attack: newAttack);
  }

  /// Augmente les points de vie du pathogène.
  PathogenEntity _increaseHealth(PathogenEntity pathogen) {
    final newHealth =
    (pathogen.health * GameConstants.mutationHpMultiplier).round();
    return pathogen.copyWith(health: newHealth);
  }


  // PathogenEntity _increaseSpeed(PathogenEntity pathogen) {
  //   final newSpeed =
  //       pathogen.attackSpeed * GameConstants.mutationSpeedMultiplier;
  //   return pathogen.copyWith(attackSpeed: newSpeed);
  // }

  /// Augmente la résistance du pathogène.
  PathogenEntity _increaseResistance(PathogenEntity pathogen) {
    // La logique de résistance pourrait être plus complexe (ajouter un nouveau type, augmenter une valeur existante, etc.)
    // Ici, on va simplement changer le type de résistance aléatoirement.
    final availableTypes = ResistanceType.values.toList();
    final newResistanceType = availableTypes[_random.nextInt(availableTypes.length)];
    return pathogen.copyWith(resistanceType: newResistanceType);
  }

  /// Vérifie si une mutation est considérée comme majeure.
  bool isMajorMutation(PathogenEntity oldPathogen, PathogenEntity newPathogen) {
    final attackDiff = (newPathogen.attack - oldPathogen.attack) / oldPathogen.attack;
    final healthDiff = (newPathogen.health - oldPathogen.health) / oldPathogen.health;
    // Pas de comparaison de vitesse car PathogenEntity n'a pas de propriété de vitesse directe

    return attackDiff > GameConstants.majorMutationThreshold ||
        healthDiff > GameConstants.majorMutationThreshold;
  }


}
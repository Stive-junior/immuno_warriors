import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/combat_repository.dart';

class GetCombatTacticalAdviceUseCase {
  final CombatRepository _combatRepository;

  GetCombatTacticalAdviceUseCase(this._combatRepository);

  Future<String?> execute({String? gameState, String? enemyBaseInfo}) async {
    try {
      return await _combatRepository.getCombatTacticalAdvice(gameState: gameState, enemyBaseInfo: enemyBaseInfo);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting combat tactical advice: $e');
      }
      return null;
    }
  }
}
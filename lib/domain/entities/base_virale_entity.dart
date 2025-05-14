import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';

class BaseViraleEntity {
  final String id;
  final String playerId;
  final String name;
  final int level;
  final List<PathogenEntity> pathogens;
  final Map<DefenseType, int> defenses;

  BaseViraleEntity({
    required this.id,
    required this.playerId,
    required this.name,
    required this.level,
    required this.pathogens,
    required this.defenses,
  });

  int getTotalDefense() {
    int total = 0;
    defenses.forEach((key, value) {
      total += value;
    });
    return total;
  }

  @override
  String toString() {
    return 'BaseViraleEntity{id: $id, playerId: $playerId, name: $name, level: $level, pathogens: $pathogens, defenses: $defenses}';
  }
}
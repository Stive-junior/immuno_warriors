import 'package:hive/hive.dart';
import 'package:immuno_warriors/data/models/pathogen_model.dart';
import '../../../core/constants/pathogen_types.dart';
import '../../../domain/entities/base_virale_entity.dart';

part 'base_viral_model.g.dart';

@HiveType(typeId: 13)
class BaseViraleModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String playerId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final int level;
  @HiveField(4)
  final List<PathogenModel> pathogens;
  @HiveField(5)
  final Map<String, int> defenses;

  BaseViraleModel({
    required this.id,
    required this.playerId,
    required this.name,
    required this.level,
    required this.pathogens,
    required this.defenses,
  });

  factory BaseViraleModel.fromJson(Map<String, dynamic> json) {
    return BaseViraleModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      pathogens:
          (json['pathogens'] as List<dynamic>?)
              ?.map((p) => PathogenModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      defenses:
          (json['defenses'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v as int),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'name': name,
    'level': level,
    'pathogens': pathogens.map((p) => p.toJson()).toList(),
    'defenses': defenses,
  };

  factory BaseViraleModel.fromEntity(BaseViraleEntity entity) {
    return BaseViraleModel(
      id: entity.id,
      playerId: entity.playerId,
      name: entity.name,
      level: entity.level,
      pathogens:
          entity.pathogens.map((p) => PathogenModel.fromEntity(p)).toList(),
      defenses: entity.defenses.map(
        (k, v) => MapEntry(k.toString().split('.').last, v),
      ),
    );
  }

  BaseViraleEntity toEntity() {
    return BaseViraleEntity(
      id: id,
      playerId: playerId,
      name: name,
      level: level,
      pathogens: pathogens.map((p) => p.toEntity()).toList(),
      defenses: defenses.map(
        (k, v) => MapEntry(
          DefenseType.values.firstWhere(
            (e) => e.toString().split('.').last == k,
          ),
          v,
        ),
      ),
    );
  }

  /// Validates if the base is ready for combat.
  bool get isCombatReady =>
      pathogens.isNotEmpty && defenses.values.any((v) => v > 0);
}

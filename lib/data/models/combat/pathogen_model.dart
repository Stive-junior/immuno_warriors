// Model for storing pathogen data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import '../../../core/constants/pathogen_types.dart';
import '../../../domain/entities/combat/pathogen_entity.dart';

part 'pathogen_model.g.dart';

@HiveType(typeId: 17)
class PathogenModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final PathogenType type;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final int health;
  @HiveField(4)
  final int attack;
  @HiveField(5)
  final AttackType attackType;
  @HiveField(6)
  final ResistanceType resistanceType;
  @HiveField(7)
  final PathogenRarity rarity;
  @HiveField(8)
  final double mutationRate;
  @HiveField(9)
  final List<String>? abilities;

  PathogenModel({
    required this.id,
    required this.type,
    required this.name,
    required this.health,
    required this.attack,
    required this.attackType,
    required this.resistanceType,
    required this.rarity,
    required this.mutationRate,
    this.abilities,
  });

  factory PathogenModel.fromJson(Map<String, dynamic> json) =>
      PathogenModel.fromEntity(PathogenEntity.fromJson(json));

  Map<String, dynamic> toJson() => toEntity().toJson();

  factory PathogenModel.fromEntity(PathogenEntity entity) {
    return PathogenModel(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      health: entity.health,
      attack: entity.attack,
      attackType: entity.attackType,
      resistanceType: entity.resistanceType,
      rarity: entity.rarity,
      mutationRate: entity.mutationRate,
      abilities: entity.abilities,
    );
  }

  PathogenEntity toEntity() {
    return PathogenEntity(
      id: id,
      type: type,
      name: name,
      health: health,
      attack: attack,
      attackType: attackType,
      resistanceType: resistanceType,
      rarity: rarity,
      mutationRate: mutationRate,
      abilities: abilities,
    );
  }

  /// Validates if the pathogen is combat-ready.
  bool get isCombatReady => health > 0 && attack >= 0;
}

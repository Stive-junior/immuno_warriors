/// Model for storing antibody data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import '../../core/constants/pathogen_types.dart';
import '../../domain/entities/antibody_entity.dart';

part 'antibody_model.g.dart';

@HiveType(typeId: 1)
class AntibodyModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final AntibodyType type;
  @HiveField(2)
  final AttackType attackType;
  @HiveField(3)
  final int damage;
  @HiveField(4)
  final int range;
  @HiveField(5)
  final int cost;
  @HiveField(6)
  final double efficiency;
  @HiveField(7)
  final String name;
  @HiveField(8)
  final int health;
  @HiveField(9)
  final int maxHealth;
  @HiveField(10)
  final String? specialAbility;

  AntibodyModel({
    required this.id,
    required this.type,
    required this.attackType,
    required this.damage,
    required this.range,
    required this.cost,
    required this.efficiency,
    required this.name,
    required this.health,
    required this.maxHealth,
    this.specialAbility,
  });

  factory AntibodyModel.fromJson(Map<String, dynamic> json) =>
      AntibodyModel.fromEntity(AntibodyEntity.fromJson(json));

  Map<String, dynamic> toJson() => toEntity().toJson();

  factory AntibodyModel.fromEntity(AntibodyEntity entity) {
    return AntibodyModel(
      id: entity.id,
      type: entity.type,
      attackType: entity.attackType,
      damage: entity.damage,
      range: entity.range,
      cost: entity.cost,
      efficiency: entity.efficiency,
      name: entity.name,
      health: entity.health,
      maxHealth: entity.maxHealth,
      specialAbility: entity.specialAbility,
    );
  }

  AntibodyEntity toEntity() {
    return AntibodyEntity(
      id: id,
      type: type,
      attackType: attackType,
      damage: damage,
      range: range,
      cost: cost,
      efficiency: efficiency,
      name: name,
      health: health,
      maxHealth: maxHealth,
      specialAbility: specialAbility,
    );
  }

  bool get isDeployable => health > 0 && cost >= 0;
}
import 'package:hive/hive.dart';
import '../../../core/constants/pathogen_types.dart';
import '../../../domain/entities/combat/antibody_entity.dart';

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

  factory AntibodyModel.fromJson(Map<String, dynamic> json) {
    return AntibodyModel(
      id: json['id'] as String,
      type: _decodeAntibodyType(json['type'] as String),
      attackType: _decodeAttackType(json['attackType'] as String),
      damage: json['damage'] as int,
      range: json['range'] as int,
      cost: json['cost'] as int,
      efficiency: (json['efficiency'] as num).toDouble(),
      name: json['name'] as String,
      health: json['health'] as int,
      maxHealth: json['maxHealth'] as int,
      specialAbility: json['specialAbility'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': _encodeAntibodyType(type),
    'attackType': _encodeAttackType(attackType),
    'damage': damage,
    'range': range,
    'cost': cost,
    'efficiency': efficiency,
    'name': name,
    'health': health,
    'maxHealth': maxHealth,
    'specialAbility': specialAbility,
  };

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

  static AntibodyType _decodeAntibodyType(String value) {
    switch (value) {
      case 'igG':
        return AntibodyType.igG;
      case 'igM':
        return AntibodyType.igM;
      case 'igA':
        return AntibodyType.igA;
      case 'igD':
        return AntibodyType.igD;
      case 'igE':
        return AntibodyType.igE;
      default:
        throw ArgumentError('Unknown AntibodyType: $value');
    }
  }

  static String _encodeAntibodyType(AntibodyType type) {
    return type.toString().split('.').last;
  }

  static AttackType _decodeAttackType(String value) {
    switch (value) {
      case 'physical':
        return AttackType.physical;
      case 'chemical':
        return AttackType.chemical;
      case 'energy':
        return AttackType.energy;
      default:
        throw ArgumentError('Unknown AttackType: $value');
    }
  }

  static String _encodeAttackType(AttackType type) {
    return type.toString().split('.').last;
  }
}
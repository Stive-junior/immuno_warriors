import 'package:hive/hive.dart';
import '../../../core/constants/pathogen_types.dart';
import '../../../domain/entities/combat/pathogen_entity.dart';

part 'pathogen_model.g.dart';

@HiveType(typeId: 2)
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

  factory PathogenModel.fromJson(Map<String, dynamic> json) {
    return PathogenModel(
      id: json['id'] as String,
      type: _decodePathogenType(json['type'] as String),
      name: json['name'] as String,
      health: json['health'] as int,
      attack: json['attack'] as int,
      attackType: _decodeAttackType(json['attackType'] as String),
      resistanceType: _decodeResistanceType(json['resistanceType'] as String),
      rarity: _decodePathogenRarity(json['rarity'] as String),
      mutationRate: (json['mutationRate'] as num).toDouble(),
      abilities: (json['abilities'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': _encodePathogenType(type),
    'name': name,
    'health': health,
    'attack': attack,
    'attackType': _encodeAttackType(attackType),
    'resistanceType': _encodeResistanceType(resistanceType),
    'rarity': _encodePathogenRarity(rarity),
    'mutationRate': mutationRate,
    'abilities': abilities,
  };

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
      initialResistanceType: resistanceType,
      rarity: rarity,
      mutationRate: mutationRate,
      abilities: abilities,
    );
  }

  static PathogenType _decodePathogenType(String value) {
    switch (value) {
      case 'virus':
        return PathogenType.virus;
      case 'bacteria':
        return PathogenType.bacteria;
      case 'fungus':
        return PathogenType.fungus;
      default:
        throw ArgumentError('Unknown PathogenType: $value');
    }
  }

  static String _encodePathogenType(PathogenType type) {
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

  static ResistanceType _decodeResistanceType(String value) {
    switch (value) {
      case 'physical':
        return ResistanceType.physical;
      case 'chemical':
        return ResistanceType.chemical;
      case 'energy':
        return ResistanceType.energy;
      default:
        throw ArgumentError('Unknown ResistanceType: $value');
    }
  }

  static String _encodeResistanceType(ResistanceType type) {
    return type.toString().split('.').last;
  }

  static PathogenRarity _decodePathogenRarity(String value) {
    switch (value) {
      case 'common':
        return PathogenRarity.common;
      case 'uncommon':
        return PathogenRarity.uncommon;
      case 'rare':
        return PathogenRarity.rare;
      case 'epic':
        return PathogenRarity.epic;
      case 'legendary':
        return PathogenRarity.legendary;
      default:
        throw ArgumentError('Unknown PathogenRarity: $value');
    }
  }

  static String _encodePathogenRarity(PathogenRarity rarity) {
    return rarity.toString().split('.').last;
  }
}
import '../../../core/constants/pathogen_types.dart'; // Utilisation d'un chemin plus standard pour les enums

/// Représente une entité pathogène dans le jeu.
class PathogenEntity {
  /// Identifiant unique du pathogène.
  final String id;

  /// Type de pathogène (virus, bactérie, etc.).
  final PathogenType type;

  /// Nom du pathogène.
  final String name;

  /// Points de vie actuels du pathogène.
  final int health;

  /// Valeur d'attaque du pathogène.
  final int attack;

  /// Type d'attaque principal du pathogène.
  final AttackType attackType;

  /// Type de résistance du pathogène. Initialisé tardivement.
  late final ResistanceType resistanceType;

  /// Rareté du pathogène (commun, rare, etc.).
  final PathogenRarity rarity;

  /// Probabilité de mutation du pathogène.
  final double mutationRate;

  /// Liste des capacités spéciales du pathogène (si existantes).
  final List<String>? abilities;

  /// Constructeur pour créer une instance de [PathogenEntity].
  PathogenEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.health,
    required this.attack,
    required this.attackType,
    required ResistanceType initialResistanceType,
    required this.rarity,
    required this.mutationRate,
    this.abilities,
  }) : resistanceType = initialResistanceType;

  /// Crée une nouvelle instance de [PathogenEntity] avec des propriétés potentiellement modifiées.
  PathogenEntity copyWith({
    String? id,
    PathogenType? type,
    String? name,
    int? health,
    int? attack,
    AttackType? attackType,
    ResistanceType? resistanceType,
    PathogenRarity? rarity,
    double? mutationRate,
    List<String>? abilities,
  }) {
    return PathogenEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      health: health ?? this.health,
      attack: attack ?? this.attack,
      attackType: attackType ?? this.attackType,
      initialResistanceType: resistanceType ?? this.resistanceType,
      rarity: rarity ?? this.rarity,
      mutationRate: mutationRate ?? this.mutationRate,
      abilities: abilities ?? this.abilities,
    );
  }

  /// Convertit l'entité [PathogenEntity] en une map pour la sérialisation (par exemple, JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'name': name,
      'health': health,
      'attack': attack,
      'attackType': attackType.toString().split('.').last,
      'resistanceType': resistanceType.toString().split('.').last,
      'rarity': rarity.toString().split('.').last,
      'mutationRate': mutationRate,
      'abilities': abilities,
    };
  }

  /// Crée une instance de [PathogenEntity] à partir d'une map (par exemple, JSON).
  factory PathogenEntity.fromJson(Map<String, dynamic> json) {
    return PathogenEntity(
      id: json['id'] as String,
      type: _decodePathogenType(json['type'] as String),
      name: json['name'] as String,
      health: json['health'] as int,
      attack: json['attack'] as int,
      attackType: _decodeAttackType(json['attackType'] as String),
      initialResistanceType: _decodeResistanceType(json['resistanceType'] as String),
      rarity: _decodePathogenRarity(json['rarity'] as String),
      mutationRate: (json['mutationRate'] as num).toDouble(),
      abilities: (json['abilities'] as List<dynamic>?)?.cast<String>(),
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
}
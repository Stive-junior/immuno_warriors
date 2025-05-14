import '../../../core/constants/pathogen_types.dart'; // Utilisation d'un chemin plus standard pour les enums

/// Représente une entité anticorps dans le jeu.
class AntibodyEntity {
  /// Identifiant unique de l'anticorps.
  final String id;

  /// Type d'anticorps (IgG, IgM, etc.).
  final AntibodyType type;

  /// Type d'attaque principal de l'anticorps.
  final AttackType attackType;

  /// Valeur des dégâts infligés par l'anticorps.
  final int damage;

  /// Portée de l'attaque de l'anticorps.
  final int range;

  /// Coût de production de l'anticorps.
  final int cost;

  /// Efficacité de l'anticorps (peut influencer des effets spéciaux).
  final double efficiency;

  /// Nom de l'anticorps.
  final String name;

  /// Points de vie actuels de l'anticorps.
  int health; // Ajout de la propriété health

  /// Points de vie maximum de l'anticorps.
  final int maxHealth; // Ajout de la propriété maxHealth

  /// Capacité spéciale de l'anticorps (si existante).
  final String? specialAbility; // Ajout de la propriété specialAbility

  /// Constructeur pour créer une instance de [AntibodyEntity].
  AntibodyEntity({
    required this.id,
    required this.type,
    required this.attackType,
    required this.damage,
    required this.range,
    required this.cost,
    required this.efficiency,
    required this.name,
    required this.health, // Initialisation de health
    required this.maxHealth, // Initialisation de maxHealth
    this.specialAbility, // Initialisation de specialAbility
  });

  /// Crée une nouvelle instance de [AntibodyEntity] avec des propriétés potentiellement modifiées.
  AntibodyEntity copyWith({
    String? id,
    AntibodyType? type,
    AttackType? attackType,
    int? damage,
    int? range,
    int? cost,
    double? efficiency,
    String? name,
    int? health,
    int? maxHealth,
    String? specialAbility,
  }) {
    return AntibodyEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      attackType: attackType ?? this.attackType,
      damage: damage ?? this.damage,
      range: range ?? this.range,
      cost: cost ?? this.cost,
      efficiency: efficiency ?? this.efficiency,
      name: name ?? this.name,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      specialAbility: specialAbility ?? this.specialAbility,
    );
  }

  /// Convertit l'entité [AntibodyEntity] en une map pour la sérialisation (par exemple, JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'attackType': attackType.toString().split('.').last,
      'damage': damage,
      'range': range,
      'cost': cost,
      'efficiency': efficiency,
      'name': name,
      'health': health,
      'maxHealth': maxHealth,
      'specialAbility': specialAbility,
    };
  }

  /// Crée une instance de [AntibodyEntity] à partir d'une map (par exemple, JSON).
  factory AntibodyEntity.fromJson(Map<String, dynamic> json) {
    return AntibodyEntity(
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
}
/// Defines entity types and behaviors for Immuno Warriors.
///
/// The file contains enums for pathogen types, attack types, resistance types,
/// rarities, antibodies,
/// antibodies, and defenses, with metadata for UI and game logic.
import 'package:flutter/material.dart';

/// Types of pathogens in the game.
enum PathogenType {
  virus('Virus', 'assets/images/pathogens/virus.png', Colors.red),
  bacteria(
    'Bactérie',
    'assets/images/pathogens/pathogens/bacteria.png',
    Colors.green,
  ),
  fungus('Champignon', 'assets/images/fatal/pathogens/fungi.png', Colors.brown);

  const PathogenType(this.displayName, this.iconPath, this.color);

  /// Display name for UI.
  final String displayName;
  final String iconPath;
  final Color color;

  /// Converts a string to a [PathogenType].
  static PathogenType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => virus);
}

/// Types of attacks for units.
enum AttackType {
  physical('Physique', Colors.brown),
  chemical('Chimique', Colors.limeAccent),
  energy('Énergie', Colors.purpleAccent);

  const AttackType(this.displayName, this.color);

  /// Display name for UI.
  final String displayName;
  final Color color;

  /// Converts a string to an [AttackType].
  static AttackType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => physical);
}

/// Types of resistances for units.
enum ResistanceType {
  physical('Physique', Colors.brown),
  chemical('Chimique', Colors.limeAccent),
  energy('Énergie', Colors.purpleAccent);

  const ResistanceType(this.displayName, this.color);

  /// Display name for UI.
  final String displayName;

  /// Associated color for UI.
  final Color color;

  /// Converts a string to a [ResistanceType].
  static ResistanceType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => physical);
}

/// Rarity levels for pathogens.
enum PathogenRarity {
  common('Commun', 1.0),
  uncommon('Peu commun', 1.2),
  rare('Rare', 1.5),
  epic('Épique', 2.0),
  legendary('Légendaire', 3.0);

  const PathogenRarity(this.displayName, this.multiplier);

  /// Display name for UI.
  final String displayName;

  /// Multiplier for stats based on rarity.
  final double multiplier;

  /// Converts a string to a [PathogenRarity].
  static PathogenRarity fromString(String value) =>
      values.firstWhere((rarity) => rarity.name == value, orElse: () => common);
}

/// Types of antibodies.
enum AntibodyType {
  igG('IgG', 'assets/images/antibodies/igg.png'),
  igM('IgM', 'assets/images/antibodies/igm.png'),
  igA('IgA', 'assets/images/antibodies/iga.png'),
  igD('IgD', 'assets/images/antibodies/igd.png'),
  igE('IgE', 'assets/images/antibodies/ige.png');

  const AntibodyType(this.displayName, this.iconPath);

  /// Display name for UI.
  final String displayName;

  /// Path to the antibody's icon.
  final String iconPath;

  /// Converts a string to an [AntibodyType].
  static AntibodyType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => igG);
}

/// Types of defensive structures.
enum DefenseType {
  wall('Mur', 'assets/images/defenses/wall.png'),
  trap('Piège', 'assets/images/defenses/trap.png'),
  shield('Bouclier', 'assets/images/defenses/shield.png'),
  turret('Tourelle', 'assets/images/defenses/turret.png');

  const DefenseType(this.displayName, this.iconPath);

  /// Display name for UI.
  final String displayName;

  /// Path to the defense's icon.
  final String iconPath;

  /// Converts a string to a [DefenseType].
  static DefenseType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => wall);
}

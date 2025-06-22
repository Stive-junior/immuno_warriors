// Defines entity types and behaviors for Immuno Warriors.
//
// This file contains enums for pathogen types, attack types, resistance types,
// rarities, antibodies, and defenses, with metadata for UI and game logic.
// Includes additional types for expanded features like multiplayer and research.
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Types of pathogens in the game.
enum PathogenType {
  virus('Virus', 'assets/images/pathogens/virus.png', AppColors.physicalAttack),
  bacteria(
    'Bactérie',
    'assets/images/pathogens/bacteria.png',
    AppColors.chemicalAttack,
  ),
  fungus(
    'Champignon',
    'assets/images/pathogens/fungi.png',
    AppColors.energyAttack,
  ),
  parasite(
    'Parasite',
    'assets/images/pathogens/parasite.png',
    AppColors.accent,
  );

  const PathogenType(this.displayName, this.iconPath, this.color);

  /// Display name for UI.
  final String displayName;

  /// Path to the pathogen's icon.
  final String iconPath;

  /// Associated color for UI.
  final Color color;

  /// Converts a string to a [PathogenType].
  static PathogenType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => virus);
}

/// Types of attacks for units.
enum AttackType {
  physical('Physique', AppColors.physicalAttack),
  chemical('Chimique', AppColors.chemicalAttack),
  energy('Énergie', AppColors.energyAttack),
  bio('Biologique', AppColors.bioMaterialColor);

  const AttackType(this.displayName, this.color);

  /// Display name for UI.
  final String displayName;

  /// Associated color for UI.
  final Color color;

  /// Converts a string to an [AttackType].
  static AttackType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => physical);
}

/// Types of resistances for units.
enum ResistanceType {
  physical('Physique', AppColors.physicalAttack),
  chemical('Chimique', AppColors.chemicalAttack),
  energy('Énergie', AppColors.energyAttack),
  bio('Biologique', AppColors.bioMaterialColor);

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
  igE('IgE', 'assets/images/antibodies/ige.png'),
  custom('Personnalisé', 'assets/images/antibodies/custom.png');

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
  turret('Tourelle', 'assets/images/defenses/turret.png'),
  barrier('Barrière', 'assets/images/defenses/barrier.png');

  const DefenseType(this.displayName, this.iconPath);

  /// Display name for UI.
  final String displayName;

  /// Path to the defense's icon.
  final String iconPath;

  /// Converts a string to a [DefenseType].
  static DefenseType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => wall);
}

/// Types of research nodes for the research tree.
enum ResearchNodeType {
  attack('Amélioration Attaque', 'assets/images/research/attack.png'),
  defense('Amélioration Défense', 'assets/images/research/defense.png'),
  speed('Amélioration Vitesse', 'assets/images/research/speed.png'),
  efficiency(
    'Efficacité des Ressources',
    'assets/images/research/efficiency.png',
  );

  const ResearchNodeType(this.displayName, this.iconPath);

  /// Display name for UI.
  final String displayName;

  /// Path to the research node's icon.
  final String iconPath;

  /// Converts a string to a [ResearchNodeType].
  static ResearchNodeType fromString(String value) =>
      values.firstWhere((type) => type.name == value, orElse: () => attack);
}

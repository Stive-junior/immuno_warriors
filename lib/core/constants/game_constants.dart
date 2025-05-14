
class GameConstants {
  // Ressources de base
  static const int initialEnergy = 100;
  static const int initialBioMaterials = 100;
  static const int energyRegenRate = 5; // Taux de régénération de l'énergie par tick
  static const int bioMaterialRegenRate = 5; // Taux de régénération des bio-matériaux par tick
  static const double energyPerTurn = 10; // Coût énergétique par action
  static const double bioMaterialsPerTurn = 10; // Coût en bio-matériaux par action

  // Mémoire Immunitaire
  static const int memoryCapacity = 100; // Capacité maximale de la mémoire immunitaire
  static const double memoryBonusPerSignature = 0.01; // Bonus par signature dans la mémoire
  static const double majorMutationThreshold = 0.2; // Seuil pour considérer une mutation comme majeure

  // Combat
  static const int maxSquadSize = 5; // Taille maximale d'une escouade de combat
  static const double baseAttackDamage = 10.0; // Dégâts de base pour les unités
  static const double baseHp = 100.0; // Points de vie de base pour les unités
  static const double attackSpeedMultiplier = 1.0; // Multiplicateur de la vitesse d'attaque
  static const int maxCombatTurns = 20; // Nombre maximal de tours dans un combat
  static const double combatStartDelay = 2.0; // Délai avant le début du combat (en secondes)
  static const double baseDefenseFactor = 0.5; // Facteur de réduction des dégâts pour les bases
  static const int baseShieldHp = 50; // Points de vie du bouclier de base
  static const double shieldRegenRate = 2; // Taux de régénération du bouclier

  // Recherche
  static const int baseResearchPointsPerCombat = 10; // Points de recherche gagnés par combat
  static const int baseResearchPointsPerSecond = 1; // Points de recherche gagnés par seconde
  static const int maxResearchLevel = 100; // Niveau maximal de recherche

  // BioForge
  static const int maxPathogenSlots = 9; // Nombre maximal d'emplacements pour les pathogènes
  static const int initialBaseSlots = 3; // Nombre initial d'emplacements de base
  static const int maxBaseLevel = 10; // Niveau maximal des bases

  // Pathogènes
  static const double basePathogenDamage = 15.0; // Dégâts de base des pathogènes
  static const double basePathogenHp = 80.0; // Points de vie de base des pathogènes
  static const double pathogenAttackSpeed = 1.2; // Vitesse d'attaque des pathogènes
  static const double pathogenSpawnInterval = 5.0; // Intervalle d'apparition des pathogènes (en secondes)

  // Anticorps
  static const double baseAntibodyDamage = 20.0; // Dégâts de base des anticorps
  static const double baseAntibodyHp = 120.0; // Points de vie de base des anticorps
  static const double antibodyAttackSpeed = 1.5; // Vitesse d'attaque des anticorps
  static const double antibodyCost = 20.0; // Coût de production des anticorps
  static const int antibodyMaxLevel = 20; // Niveau maximal des anticorps

  // Mutations
  static const double mutationDamageMultiplier = 1.1; // Multiplicateur de dégâts pour les mutations
  static const double mutationHpMultiplier = 1.1; // Multiplicateur de points de vie pour les mutations
  static const double mutationSpeedMultiplier = 1.1; // Multiplicateur de vitesse pour les mutations
  static const double mutationResistanceMultiplier = 1.1; // Multiplicateur de résistance pour les mutations

  // IA Analyste (Gemini)
  static const int maxGeminiTokens = 200; // Limite de tokens pour les requêtes à Gemini
  static const String geminiPrompt = "Agis comme un conseiller militaire expérimenté dans un jeu de stratégie de défense immunitaire. Fournis des conseils tactiques, des analyses de combat et des informations sur les menaces.";

  // Threat Scanner
  static const int threatScanRadius = 10; // Rayon de la zone de scan
  static const int threatScanMaxResults = 20; // Nombre maximal de résultats du scan

  // War Archive
  static const int maxArchiveReports = 50; // Nombre maximal de rapports archivés
  static const int chronicleLength = 300; // Longueur de la chronique (en mots)

  // Niveaux de difficulté
  static const double easyDifficultyMultiplier = 0.8;
  static const double mediumDifficultyMultiplier = 1.0;
  static const double hardDifficultyMultiplier = 1.2;

  // Récompenses
  static const int baseResourcesPerWin = 50;
  static const int baseExperiencePerWin = 20;

  // Coûts de construction et d'amélioration
  static const int baseUpgradeCostMultiplier = 2;
  static const int baseBuildingCost = 100;
  static const int antibodyProductionTime = 10; // Temps de production d'un anticorps (en secondes)
}
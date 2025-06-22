/// Constants defining the rules and parameters for Immuno Warriors.
///
/// This file groups constants for resources, combat, research, and other game mechanics.
/// Includes parameters for features like BioForge, multiplayer, and threat scanner.
class GameConstants {
  /// --- Resources ---
  /// Initial energy available to the player.
  static const int initialEnergy = 100;

  /// Initial bio-materials available to the player.
  static const int initialBioMaterials = 100;

  /// Energy regeneration rate per tick.
  static const int energyRegenRate = 5;

  /// Bio-materials regeneration rate per tick.
  static const int bioMaterialRegenRate = 5;

  /// Energy cost per action in combat or BioForge.
  static const double energyPerTurn = 10;

  /// Bio-materials cost per action in BioForge or research.
  static const double bioMaterialsPerTurn = 10;

  /// Maximum energy capacity.
  static const int maxEnergy = 500;

  /// Maximum bio-materials capacity.
  static const int maxBioMaterials = 500;

  /// --- Immune Memory ---
  /// Maximum capacity of the immune memory for storing signatures.
  static const int memoryCapacity = 100;

  /// Bonus per signature in the immune memory (e.g., damage boost).
  static const double memoryBonusPerSignature = 0.01;

  /// Threshold for considering a mutation as major.
  static const double majorMutationThreshold = 0.2;

  /// --- Combat ---
  /// Maximum size of a combat squad.
  static const int maxSquadSize = 5;

  /// Base attack damage for units.
  static const double baseAttackDamage = 10.0;

  /// Base hit points for units.
  static const double baseHp = 100.0;

  /// Multiplier for attack speed.
  static const double attackSpeedMultiplier = 1.0;

  /// Maximum number of turns in a combat.
  static const int maxCombatTurns = 20;

  /// Delay before combat starts (in seconds).
  static const double combatStartDelay = 2.0;

  /// Damage reduction factor for bases.
  static const double baseDefenseFactor = 0.5;

  /// Hit points of a base's shield.
  static const int baseShieldHp = 50;

  /// Shield regeneration rate per tick.
  static const double shieldRegenRate = 2;

  /// Critical hit chance (percentage).
  static const double criticalHitChance = 0.1;

  /// Critical hit damage multiplier.
  static const double criticalHitMultiplier = 1.5;

  /// --- Research ---
  /// Research points gained per combat.
  static const int baseResearchPointsPerCombat = 10;

  /// Research points gained per second.
  static const int baseResearchPointsPerSecond = 1;

  /// Maximum research level.
  static const int maxResearchLevel = 100;

  /// Research cost multiplier per level.
  static const double researchCostMultiplier = 1.5;

  /// --- BioForge ---
  /// Maximum number of pathogen slots in BioForge.
  static const int maxPathogenSlots = 9;

  /// Initial number of base slots for BioForge.
  static const int initialBaseSlots = 3;

  /// Maximum level for bases.
  static const int maxBaseLevel = 10;

  /// BioForge crafting time per antibody (in seconds).
  static const int bioForgeCraftTime = 15;

  /// --- Pathogens ---
  /// Base damage for pathogens.
  static const double basePathogenDamage = 15.0;

  /// Base hit points for pathogens.
  static const double basePathogenHp = 80.0;

  /// Attack speed for pathogens.
  static const double pathogenAttackSpeed = 1.2;

  /// Interval between pathogen spawns (in seconds).
  static const double pathogenSpawnInterval = 5.0;

  /// Pathogen resistance multiplier.
  static const double pathogenResistance = 0.8;

  /// --- Antibodies ---
  /// Base damage for antibodies.
  static const double baseAntibodyDamage = 20.0;

  /// Base hit points for antibodies.
  static const double baseAntibodyHp = 120.0;

  /// Attack speed for antibodies.
  static const double antibodyAttackSpeed = 1.5;

  /// Production cost for antibodies.
  static const double antibodyCost = 20.0;

  /// Maximum level for antibodies.
  static const int antibodyMaxLevel = 20;

  /// --- Mutations ---
  /// Damage multiplier for mutations.
  static const double mutationDamageMultiplier = 1.1;

  /// Hit points multiplier for mutations.
  static const double mutationHpMultiplier = 1.1;

  /// Speed multiplier for mutations.
  static const double mutationSpeedMultiplier = 1.1;

  /// Resistance multiplier for mutations.
  static const double mutationResistanceMultiplier = 1.1;

  /// Mutation chance per combat (percentage).
  static const double mutationChance = 0.05;

  /// --- Gemini AI ---
  /// Maximum tokens for Gemini AI requests.
  static const int maxGeminiTokens = 200;

  /// Prompt for the Gemini AI advisor.
  static const String geminiPrompt =
      'Act as an experienced military advisor in a strategy game of immune defense. '
      'Provide tactical advice, combat analysis, and threat insights.';

  /// Cooldown for Gemini AI requests (in seconds).
  static const int geminiCooldown = 30;

  /// --- Threat Scanner ---
  /// Radius of the threat scan area (in game units).
  static const int threatScanRadius = 10;

  /// Maximum number of scan results.
  static const int threatScanMaxResults = 20;

  /// Threat scan duration (in seconds).
  static const double threatScanDuration = 3.0;

  /// --- War Archive ---
  /// Maximum number of archived combat reports.
  static const int maxArchiveReports = 50;

  /// Length of a chronicle (in words).
  static const int chronicleLength = 300;

  /// --- Multiplayer ---
  /// Maximum players in a multiplayer session.
  static const int maxMultiplayerPlayers = 4;

  /// Multiplayer session timeout (in minutes).
  static const int multiplayerSessionTimeout = 30;

  /// --- Difficulty Multipliers ---
  /// Multiplier for easy difficulty.
  static const double easyDifficultyMultiplier = 0.8;

  /// Multiplier for medium difficulty.
  static const double mediumDifficultyMultiplier = 1.0;

  /// Multiplier for hard difficulty.
  static const double hardDifficultyMultiplier = 1.2;

  /// --- Rewards ---
  /// Resources gained per combat win.
  static const int baseResourcesPerWin = 50;

  /// Experience gained per combat win.
  static const int baseExperiencePerWin = 20;

  /// Multiplayer win resource bonus.
  static const int multiplayerWinBonus = 100;

  /// --- Construction and Upgrades ---
  /// Multiplier for upgrade costs.
  static const int baseUpgradeCostMultiplier = 2;

  /// Cost for constructing a base.
  static const int baseBuildingCost = 100;

  /// Time to produce an antibody (in seconds).
  static const int antibodyProductionTime = 10;

  /// Upgrade time per base level (in seconds).
  static const int baseUpgradeTime = 20;
}
class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String verifyToken = '/auth/verify-token';

  // Points de terminaison pour les données utilisateur

  static const String userProfile = '/user/profile';
  static const String userResources = '/user/resources';
  static const String userInventory = '/user/inventory';

  // Points de terminaison pour le combat
  static const String combatStart = '/combat/start';
  static const String combatEnd = '/combat/end';
  static const String combatReport = '/combat/report';

  // Points de terminaison pour la recherche
  static const String researchTree = '/research/tree';
  static const String researchNode =
      '/research/node/{nodeId}'; // Exemple avec paramètre
  static const String researchProgress = '/research/progress';
  static const String researchUnlock = '/research/unlock';

  // Points de terminaison pour BioForge
  static const String bioForgeConfig = '/bioforge/config';
  static const String bioForgeDeploy = '/bioforge/deploy';
  static const String bioForgeSave = '/bioforge/save';
  static const String bioForgeLoad = '/bioforge/load';

  // Points de terminaison pour War Archive
  static const String warArchiveReports = '/war-archive/reports';
  static const String warArchiveChronicle = '/war-archive/chronicle';
  static const String warArchiveFilter = '/war-archive/filter';

  // Points de terminaison pour le Threat Scanner
  static const String threatScannerTargets = '/threat-scanner/targets';
  static const String threatScannerScan = '/threat-scanner/scan';
  static const String threatScannerNearby = '/threat-scanner/nearby';

  static const String geminiChat = '/gemini/chat';
  static const String generateCombatChronicle =
      '/gemini/generate-combat-chronicle';
  static const String getTacticalAdvice = '/gemini/get-tactical-advice';
  static const String getStoredGeminiResponses = '/gemini/stored-responses';

  /// Exemple d'utilisation d'un paramètre dans un point de terminaison.
  static String researchNodeUrl(String nodeId) {
    return '/research/node/$nodeId';
  }

  static String threatScannerScanUrl(String targetId) {
    return '/threat-scanner/scan/$targetId';
  }
}

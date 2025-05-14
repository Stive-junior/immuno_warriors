
class ApiEndpoints {
  // Base URL de l'API.  Peut être configuré pour différents environnements (dev, prod).
  static const String baseUrl = 'https://your-api.com/api'; // Remplacez par votre URL

  // Points de terminaison pour l'authentification
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyToken = '/auth/verify-token';

  // Points de terminaison pour les données utilisateur
  static const String userProfile = '/user/profile';
  static const String userSettings = '/user/settings';
  static const String userResources = '/user/resources';
  static const String userInventory = '/user/inventory';

  // Points de terminaison pour le combat
  static const String combatStart = '/combat/start';
  static const String combatEnd = '/combat/end';
  static const String combatReport = '/combat/report';
  static const String combatLog = '/combat/log';

  // Points de terminaison pour la recherche
  static const String researchTree = '/research/tree';
  static const String researchNode = '/research/node/{nodeId}'; // Exemple avec paramètre
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

  // Points de terminaison pour Gemini (si utilisé directement)
  static const String geminiChat = '/gemini/chat'; // Exemple


  /// Exemple d'utilisation d'un paramètre dans un point de terminaison.
  static String researchNodeUrl(String nodeId) {
    return '/research/node/$nodeId';
  }

  static String threatScannerScanUrl(String targetId) {
    return '/threat-scanner/scan/$targetId';
  }
}
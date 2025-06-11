/// API endpoints for Immuno Warriors.
///
/// This file defines the API routes for communication with the backend.
class ApiEndpoints {
  /// --- Configuration ---
  static const String _apiVersion = 'v1';
  static const Map<String, String> _baseUrls = {
    'development': 'http://10.0.2.2:3000/api',
    'staging': 'https://staging.immuno-warriors.com/api',
    'production': 'https://api.immuno-warriors.com/api',
  };

  /// Gets the base URL based on the current environment.
  static String get baseUrl {
    const environment = String.fromEnvironment(
      'ENV',
      defaultValue: 'development',
    );
    return _baseUrls[environment] ?? _baseUrls['development']!;
  }

  /// Builds a full endpoint URL with versioning.
  static String _buildUrl(String path) => '/$_apiVersion$path';

  /// --- Authentication ---
  static final String verifyToken = _buildUrl('/auth/verify-token');

  /// --- User ---
  static final String userProfile = _buildUrl('/user/profile');
  static final String userResources = _buildUrl('/user/resources');
  static final String userInventory = _buildUrl('/user/inventory');

  /// --- Combat ---
  static final String combatStart = _buildUrl('/combat/start');
  static final String combatEnd = _buildUrl('/combat/end');
  static final String combatReport = _buildUrl('/combat/report');

  /// --- Research ---
  static final String researchTree = _buildUrl('/research/tree');
  static final String researchProgress = _buildUrl('/research/progress');
  static final String researchUnlock = _buildUrl('/research/unlock');

  /// --- BioForge ---
  static final String bioForgeConfig = _buildUrl('/bioforge/config');
  static final String bioForgeDeploy = _buildUrl('/bioforge/deploy');
  static final String bioForgeSave = _buildUrl('/bioforge/save');
  static final String bioForgeLoad = _buildUrl('/bioforge/load');

  /// --- War Archive ---
  static final String warArchiveReports = _buildUrl('/war-archive/reports');
  static final String warArchiveChronicle = _buildUrl('/war-archive/chronicle');
  static final String warArchiveFilter = _buildUrl('/war-archive/filter');

  /// --- Threat Scanner ---
  static final String threatScannerTargets = _buildUrl(
    '/threat-scanner/targets',
  );
  static final String threatScannerNearby = _buildUrl('/threat-scanner/nearby');

  /// --- Gemini AI ---
  static final String geminiChat = _buildUrl('/gemini/chat');
  static final String generateCombatChronicle = _buildUrl(
    '/gemini/generate-combat-chronicle',
  );
  static final String getTacticalAdvice = _buildUrl(
    '/gemini/get-tactical-advice',
  );
  static final String getStoredGeminiResponses = _buildUrl(
    '/gemini/stored-responses',
  );

  /// --- Future Features ---
  static final String leaderboard = _buildUrl('/leaderboard');
  static final String multiplayerJoin = _buildUrl('/multiplayer/join');
  static final String multiplayerStatus = _buildUrl('/multiplayer/status');

  /// --- Parameterized Endpoints ---

  /// Builds the research node endpoint with a specific [nodeId].
  static String researchNodeUrl(String nodeId) =>
      _buildUrl('/research/node/$nodeId');

  /// Builds the threat scanner scan endpoint with a specific [targetId].
  static String threatScannerScanUrl(String targetId) =>
      _buildUrl('/threat-scanner/scan/$targetId');
}

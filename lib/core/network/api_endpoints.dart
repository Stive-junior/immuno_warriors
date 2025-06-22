/// API endpoints for Immuno Warriors.
///
/// This file defines the API routes for communication with the backend.
/// Each endpoint corresponds to a route or sub-route defined in the backend (app.js and associated route files)
/// and includes the HTTP method, expected parameters, and description.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import '../../features/auth/providers/auth_provider.dart';

class ApiEndpoints {
  /// Gets the base URL from NetworkService and ensures '/api' is appended correctly.
  static String baseUrl(WidgetRef ref) {
    final networkService = ref.read(networkServiceProvider);
    final baseUrl = networkService.baseUrl;

    if (baseUrl.isEmpty || !isValidUrl(baseUrl)) {
      AppLogger.error('Invalid or empty base URL: $baseUrl');
      const fallbackUrl = 'https://api.immunowarriors.com';
      return '$fallbackUrl/api';
    }

    // Remove any trailing '/api' to avoid duplication
    final cleanedBaseUrl = baseUrl.replaceAll(RegExp(r'/api$'), '');
    return '$cleanedBaseUrl/api';
  }

  /// Validates if a URL is well-formed.
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  /// Builds a full endpoint URL, ensuring it starts with a slash.
  static String _buildUrl(String path) =>
      path.startsWith('/') ? path : '/$path';

  /// --- Health Check ---
  /// GET /health
  /// Checks the API's health status.
  /// Parameters: None
  static final String healthCheck = _buildUrl('/health');

  /// --- Ngrok URL ---
  /// GET /ngrok-url
  /// Retrieves the current ngrok URL.
  /// Parameters: None
  static final String ngrokUrl = _buildUrl('/ngrok-url');

  /// --- Authentication ---
  /// POST /auth/sign-up
  /// Registers a new user.
  /// Parameters: { email: String, password: String, username: String }
  static final String signup = _buildUrl('/auth/sign-up');

  /// POST /auth/sign-in
  /// Logs in a user.
  /// Parameters: { email: String, password: String }
  static final String signin = _buildUrl('/auth/sign-in');

  /// GET /auth/verify-token
  /// Verifies the validity of the JWT token.
  /// Parameters: None
  static final String verifyToken = _buildUrl('/auth/verify-token');

  /// POST /auth/refresh-token
  /// Refreshes the JWT token.
  /// Parameters: { refreshToken: String }
  static final String refreshToken = _buildUrl('/auth/refresh-token');

  /// POST /auth/sign-out
  /// Logs out the current user.
  /// Parameters: None
  static final String signout = _buildUrl('/auth/sign-out');

  /// --- User ---
  /// GET /user/profile
  /// Retrieves the user's profile.
  /// Parameters: None
  static final String userProfile = _buildUrl('/user/profile');

  /// PUT /user/profile
  /// Updates the user's profile.
  /// Parameters: { username: String?, avatar: String? }
  static final String updateUserProfile = _buildUrl('/user/profile');

  /// GET /user/resources
  /// Retrieves the user's resources.
  /// Parameters: None
  static final String userResources = _buildUrl('/user/resources');

  /// POST /user/resources
  /// Adds resources to the user.
  /// Parameters: { credits: int?, energy: int? }
  static final String addUserResources = _buildUrl('/user/resources');

  /// GET /user/inventory
  /// Retrieves the user's inventory.
  /// Parameters: None
  static final String userInventory = _buildUrl('/user/inventory');

  /// POST /user/inventory
  /// Adds an item to the user's inventory.
  /// Parameters: { id: String, type: String, name: String, quantity: int }
  static final String addInventoryItem = _buildUrl('/user/inventory');

  /// DELETE /user/inventory/:itemId
  /// Removes an item from the user's inventory.
  /// Parameters: itemId (path)
  static String removeInventoryItem(String itemId) =>
      _buildUrl('/user/inventory/$itemId');

  /// GET /user/settings
  /// Retrieves the user's settings.
  /// Parameters: None
  static final String userSettings = _buildUrl('/user/settings');

  /// PUT /user/settings
  /// Updates the user's settings.
  /// Parameters: { notifications: bool?, sound: bool?, language: String? }
  static final String updateUserSettings = _buildUrl('/user/settings');

  /// DELETE /user
  /// Deletes the user's account.
  /// Parameters: None
  static final String deleteUser = _buildUrl('/user');

  /// --- Combat ---
  /// POST /combat
  /// Starts a new combat session.
  /// Parameters: { baseId: String, antibodies: List<String> }
  static final String combatStart = _buildUrl('/combat');

  /// POST /combat/:combatId/end
  /// Ends a combat session.
  /// Parameters: combatId (path), { outcome: String, stats: Object }
  static String combatEnd(String combatId) =>
      _buildUrl('/combat/$combatId/end');

  /// GET /combat/:combatId
  /// Retrieves a combat report.
  /// Parameters: combatId (path)
  static String combatReport(String combatId) => _buildUrl('/combat/$combatId');

  /// GET /combat/history
  /// Retrieves the user's combat history.
  /// Parameters: None
  static final String combatHistory = _buildUrl('/combat/history');

  /// GET /combat/:combatId/chronicle
  /// Generates a combat chronicle.
  /// Parameters: combatId (path)
  static String combatChronicle(String combatId) =>
      _buildUrl('/combat/$combatId/chronicle');

  /// GET /combat/:combatId/advice
  /// Retrieves tactical advice for a combat.
  /// Parameters: combatId (path)
  static String combatAdvice(String combatId) =>
      _buildUrl('/combat/$combatId/advice');

  /// --- Research ---
  /// GET /research/tree
  /// Retrieves the research tree.
  /// Parameters: None
  static final String researchTree = _buildUrl('/research/tree');

  /// GET /research/progress
  /// Retrieves the user's research progress.
  /// Parameters: None
  static final String researchProgress = _buildUrl('/research/progress');

  /// POST /research/unlock
  /// Unlocks a research node.
  /// Parameters: { researchId: String }
  static final String researchUnlock = _buildUrl('/research/unlock');

  /// PUT /research/node/:researchId
  /// Updates progress for a research node.
  /// Parameters: researchId (path), { progress: int }
  static String researchNodeUrl(String researchId) =>
      _buildUrl('/research/node/$researchId');

  /// --- Gemini AI ---
  /// POST /gemini/chat
  /// Initiates a chat with Gemini AI.
  /// Parameters: { message: String }
  static final String geminiChat = _buildUrl('/gemini/chat');

  /// GET /gemini/combat-chronicle/:combatId
  /// Generates a combat chronicle using Gemini AI.
  /// Parameters: combatId (path)
  static String generateCombatChronicle(String combatId) =>
      _buildUrl('/gemini/combat-chronicle/$combatId');

  /// GET /gemini/tactical-advice/:combatId
  /// Retrieves tactical advice using Gemini AI.
  /// Parameters: combatId (path)
  static String getTacticalAdvice(String combatId) =>
      _buildUrl('/gemini/tactical-advice/$combatId');

  /// GET /gemini/research-description/:researchId
  /// Generates a research description using Gemini AI.
  /// Parameters: researchId (path)
  static String generateResearchDescription(String researchId) =>
      _buildUrl('/gemini/research-description/$researchId');

  /// GET /gemini/base-description/:baseId
  /// Generates a base description using Gemini AI.
  /// Parameters: baseId (path)
  static String generateBaseDescription(String baseId) =>
      _buildUrl('/gemini/base-description/$baseId');

  /// GET /gemini/stored-responses
  /// Retrieves stored Gemini AI responses.
  /// Parameters: None
  static final String getStoredGeminiResponses =
  _buildUrl('/gemini/stored-responses');

  /// --- Base Virale ---
  /// POST /base-virale
  /// Creates a new viral base.
  /// Parameters: { name: String, location: Object }
  static final String createBase = _buildUrl('/base-virale');

  /// GET /base-virale/:baseId
  /// Retrieves a specific base.
  /// Parameters: baseId (path)
  static String getBase(String baseId) => _buildUrl('/base-virale/$baseId');

  /// GET /base-virale/player
  /// Retrieves all bases owned by the player.
  /// Parameters: None
  static final String getPlayerBases = _buildUrl('/base-virale/player');

  /// GET /base-virale
  /// Retrieves all bases.
  /// Parameters: None
  static final String getAllBases = _buildUrl('/base-virale');

  /// PUT /base-virale/:baseId
  /// Updates a base.
  /// Parameters: baseId (path), { name: String?, location: Object? }
  static String updateBase(String baseId) => _buildUrl('/base-virale/$baseId');

  /// DELETE /base-virale/:baseId
  /// Deletes a base.
  /// Parameters: baseId (path)
  static String deleteBase(String baseId) => _buildUrl('/base-virale/$baseId');

  /// POST /base-virale/:baseId/pathogens
  /// Adds a pathogen to a base.
  /// Parameters: baseId (path), { pathogenId: String }
  static String addPathogen(String baseId) =>
      _buildUrl('/base-virale/$baseId/pathogens');

  /// DELETE /base-virale/:baseId/pathogens
  /// Removes a pathogen from a base.
  /// Parameters: baseId (path), { pathogenId: String }
  static String removePathogen(String baseId) =>
      _buildUrl('/base-virale/$baseId/pathogens');

  /// PUT /base-virale/:baseId/defenses
  /// Updates a base's defenses.
  /// Parameters: baseId (path), { defenses: Object }
  static String updateDefenses(String baseId) =>
      _buildUrl('/base-virale/$baseId/defenses');

  /// POST /base-virale/:baseId/level-up
  /// Levels up a base.
  /// Parameters: baseId (path)
  static String levelUpBase(String baseId) =>
      _buildUrl('/base-virale/$baseId/level-up');

  /// GET /base-virale/:baseId/validate
  /// Validates a base for combat.
  /// Parameters: baseId (path)
  static String validateForCombat(String baseId) =>
      _buildUrl('/base-virale/$baseId/validate');

  /// --- Pathogens ---
  /// POST /pathogen
  /// Creates a new pathogen.
  /// Parameters: { name: String, type: String, rarity: String, stats: Object }
  static final String createPathogen = _buildUrl('/pathogen');

  /// GET /pathogen
  /// Retrieves all pathogens.
  /// Parameters: None
  static final String getAllPathogens = _buildUrl('/pathogen');

  /// GET /pathogen/type/:type
  /// Retrieves pathogens by type.
  /// Parameters: type (path)
  static String getPathogensByType(String type) =>
      _buildUrl('/pathogen/type/$type');

  /// GET /pathogen/rarity/:rarity
  /// Retrieves pathogens by rarity.
  /// Parameters: rarity (path)
  static String getPathogensByRarity(String rarity) =>
      _buildUrl('/pathogen/rarity/$rarity');

  /// PUT /pathogen/:pathogenId/stats
  /// Updates a pathogen's stats.
  /// Parameters: pathogenId (path), { stats: Object }
  static String updatePathogenStats(String pathogenId) =>
      _buildUrl('/pathogen/$pathogenId/stats');

  /// DELETE /pathogen/:pathogenId
  /// Deletes a pathogen.
  /// Parameters: pathogenId (path)
  static String deletePathogen(String pathogenId) =>
      _buildUrl('/pathogen/$pathogenId');

  /// --- Antibodies ---
  /// GET /antibody
  /// Retrieves all antibodies.
  /// Parameters: None
  static final String getAllAntibodies = _buildUrl('/antibody');

  /// POST /antibody
  /// Creates a new antibody.
  /// Parameters: { name: String, type: String, stats: Object }
  static final String createAntibody = _buildUrl('/antibody');

  /// GET /antibody/:antibodyId
  /// Retrieves a specific antibody.
  /// Parameters: antibodyId (path)
  static String getAntibody(String antibodyId) =>
      _buildUrl('/antibody/$antibodyId');

  /// GET /antibody/type/:type
  /// Retrieves antibodies by type.
  /// Parameters: type (path)
  static String antibodiesByType(String type) =>
      _buildUrl('/antibody/type/$type');

  /// PUT /antibody/:antibodyId
  /// Updates an antibody's stats.
  /// Parameters: antibodyId (path), { stats: Object }
  static String updateAntibodyStats(String antibodyId) =>
      _buildUrl('/antibody/$antibodyId');

  /// DELETE /antibody/:antibodyId
  /// Deletes an antibody.
  /// Parameters: antibodyId (path)
  static String deleteAntibody(String antibodyId) =>
      _buildUrl('/antibody/$antibodyId');

  /// PUT /antibody/:antibodyId/special-ability
  /// Assigns a special ability to an antibody.
  /// Parameters: antibodyId (path), { ability: String }
  static String assignSpecialAbility(String antibodyId) =>
      _buildUrl('/antibody/$antibodyId/special-ability');

  /// POST /antibody/:antibodyId/simulate
  /// Simulates the combat effect of an antibody.
  /// Parameters: antibodyId (path), { target: Object }
  static String simulateCombatEffect(String antibodyId) =>
      _buildUrl('/antibody/$antibodyId/simulate');

  /// --- Notifications ---
  /// POST /notification
  /// Creates a new notification.
  /// Parameters: { message: String, type: String }
  static final String createNotification = _buildUrl('/notification');

  /// GET /notification
  /// Retrieves the user's notifications.
  /// Parameters: None
  static final String getNotifications = _buildUrl('/notification');

  /// PUT /notification/:notificationId/read
  /// Marks a notification as read.
  /// Parameters: notificationId (path)
  static String markNotificationAsRead(String notificationId) =>
      _buildUrl('/notification/$notificationId/read');

  /// DELETE /notification/:notificationId
  /// Deletes a notification.
  /// Parameters: notificationId (path)
  static String deleteNotification(String notificationId) =>
      _buildUrl('/notification/$notificationId');

  /// PUT /notification/batch/read
  /// Marks multiple notifications as read.
  /// Parameters: { notificationIds: List<String> }
  static final String markBatchNotificationsAsRead =
  _buildUrl('/notification/batch/read');

  /// DELETE /notification/batch
  /// Deletes multiple notifications.
  /// Parameters: { notificationIds: List<String> }
  static final String deleteBatchNotifications =
  _buildUrl('/notification/batch');

  /// --- Memory Signatures ---
  /// POST /memory
  /// Adds a new memory signature.
  /// Parameters: { signature: Object }
  static final String addMemorySignature = _buildUrl('/memory');

  /// GET /memory
  /// Retrieves the user's memory signatures.
  /// Parameters: None
  static final String getUserMemorySignatures = _buildUrl('/memory');

  /// GET /memory/:signatureId/validate
  /// Validates a memory signature.
  /// Parameters: signatureId (path)
  static String validateMemorySignature(String signatureId) =>
      _buildUrl('/memory/$signatureId/validate');

  /// DELETE /memory/expired
  /// Clears expired memory signatures.
  /// Parameters: None
  static final String clearExpiredSignatures = _buildUrl('/memory/expired');

  /// --- Inventory ---
  /// POST /inventory
  /// Adds an item to the inventory.
  /// Parameters: { id: String, type: String, name: String, quantity: int }
  static final String addInventory = _buildUrl('/inventory');

  /// GET /inventory/:itemId
  /// Retrieves a specific inventory item.
  /// Parameters: itemId (path)
  static String getInventoryItem(String itemId) =>
      _buildUrl('/inventory/$itemId');

  /// GET /inventory
  /// Retrieves the user's inventory.
  /// Parameters: None
  static final String getUserInventory = _buildUrl('/inventory');

  /// PUT /inventory/:itemId
  /// Updates an inventory item.
  /// Parameters: itemId (path), { quantity: int?, name: String? }
  static String updateInventoryItem(String itemId) =>
      _buildUrl('/inventory/$itemId');

  /// DELETE /inventory/:itemId
  /// Deletes an inventory item.
  /// Parameters: itemId (path)
  static String deleteInventoryItem(String itemId) =>
      _buildUrl('/inventory/$itemId');

  /// --- Progression ---
  /// GET /progression
  /// Retrieves the user's progression.
  /// Parameters: None
  static final String getProgression = _buildUrl('/progression');

  /// POST /progression/xp
  /// Adds XP to the user's progression.
  /// Parameters: { xp: int }
  static final String addXP = _buildUrl('/progression/xp');

  /// POST /progression/mission/:missionId
  /// Completes a mission for the user.
  /// Parameters: missionId (path)
  static String completeMission(String missionId) =>
      _buildUrl('/progression/mission/$missionId');

  /// --- Achievements ---
  /// GET /achievement
  /// Retrieves all achievements.
  /// Parameters: None
  static final String getAchievements = _buildUrl('/achievement');

  /// GET /achievement/:achievementId
  /// Retrieves a specific achievement.
  /// Parameters: achievementId (path)
  static String getAchievement(String achievementId) =>
      _buildUrl('/achievement/$achievementId');

  /// GET /achievement/user
  /// Retrieves the user's achievements.
  /// Parameters: None
  static final String userAchievements = _buildUrl('/achievement/user');

  /// GET /achievement/category/:category
  /// Retrieves achievements by category.
  /// Parameters: category (path)
  static String achievementsByCategory(String category) =>
      _buildUrl('/achievement/category/$category');

  /// POST /achievement
  /// Creates a new achievement (admin only).
  /// Parameters: { name: String, description: String, category: String, reward: Object }
  static final String createAchievement = _buildUrl('/achievement');

  /// PUT /achievement/:achievementId
  /// Updates an achievement (admin only).
  /// Parameters: achievementId (path), { name: String?, description: String?, reward: Object? }
  static String updateAchievement(String achievementId) =>
      _buildUrl('/achievement/$achievementId');

  /// DELETE /achievement/:achievementId
  /// Deletes an achievement (admin only).
  /// Parameters: achievementId (path)
  static String deleteAchievement(String achievementId) =>
      _buildUrl('/achievement/$achievementId');

  /// POST /achievement/unlock
  /// Unlocks an achievement for the user.
  /// Parameters: { achievementId: String }
  static final String unlockAchievement = _buildUrl('/achievement/unlock');

  /// PUT /achievement/:achievementId/progress
  /// Updates progress for an achievement.
  /// Parameters: achievementId (path), { progress: int }
  static String updateAchievementProgress(String achievementId) =>
      _buildUrl('/achievement/$achievementId/progress');

  /// POST /achievement/claim
  /// Claims a reward for an achievement.
  /// Parameters: { achievementId: String }
  static final String claimAchievementReward = _buildUrl('/achievement/claim');

  /// POST /achievement/:achievementId/notify
  /// Notifies the user of an unlocked achievement.
  /// Parameters: achievementId (path)
  static String notifyAchievementUnlocked(String achievementId) =>
      _buildUrl('/achievement/$achievementId/notify');

  /// --- Threat Scanner ---
  /// POST /threat-test
  /// Adds a new threat.
  /// Parameters: { name: String, type: String, threatLevel: int, details: Object? }
  static final String addThreat = _buildUrl('/threat-test');

  /// GET /threat-test/:threatId
  /// Retrieves a specific threat.
  /// Parameters: threatId (path)
  static String getThreat(String threatId) =>
      _buildUrl('/threat-test/$threatId');

  /// GET /threat-test/scan/:targetId
  /// Scans a specific target for threats.
  /// Parameters: targetId (path)
  static String threatScannerScanUrl(String targetId) =>
      _buildUrl('/threat-test/scan/$targetId');

  /// --- Leaderboard ---
  /// POST /leaderboard/score
  /// Updates the user's score.
  /// Parameters: { score: int, category: String }
  static final String updateLeaderboardScore = _buildUrl('/leaderboard/score');

  /// GET /leaderboard/:category
  /// Retrieves the leaderboard for a category.
  /// Parameters: category (path)
  static String getLeaderboard(String category) =>
      _buildUrl('/leaderboard/$category');

  /// GET /leaderboard/:category/rank
  /// Retrieves the user's rank in a category.
  /// Parameters: category (path)
  static String getUserRank(String category) =>
      _buildUrl('/leaderboard/$category/rank');

  /// --- Multiplayer ---
  /// POST /multiplayer
  /// Creates a new multiplayer session.
  /// Parameters: { sessionConfig: Object }
  static final String createMultiplayerSession = _buildUrl('/multiplayer');

  /// POST /multiplayer/:sessionId/join
  /// Joins a multiplayer session.
  /// Parameters: sessionId (path)
  static String joinMultiplayerSession(String sessionId) =>
      _buildUrl('/multiplayer/$sessionId/join');

  /// GET /multiplayer/:sessionId/status
  /// Retrieves the status of a multiplayer session.
  /// Parameters: sessionId (path)
  static String getSessionStatus(String sessionId) =>
      _buildUrl('/multiplayer/$sessionId/status');

  /// GET /multiplayer
  /// Retrieves the user's multiplayer sessions.
  /// Parameters: None
  static final String getUserSessions = _buildUrl('/multiplayer');

  /// --- Sync ---
  /// POST /sync/user-data
  /// Synchronizes user data.
  /// Parameters: { localData: Object, lastSyncTimestamp: String? }
  static final String syncUserData = _buildUrl('/sync/user-data');

  /// POST /sync/inventory
  /// Synchronizes inventory data.
  /// Parameters: { localItems: List<Object>, lastSyncTimestamp: String? }
  static final String syncInventory = _buildUrl('/sync/inventory');

  /// POST /sync/threats
  /// Synchronizes threat data.
  /// Parameters: { localThreats: List<Object>, lastSyncTimestamp: String? }
  static final String syncThreats = _buildUrl('/sync/threats');

  /// POST /sync/memory-signatures
  /// Synchronizes memory signatures.
  /// Parameters: { localSignatures: List<Object>, lastSyncTimestamp: String? }
  static final String syncMemorySignatures =
  _buildUrl('/sync/memory-signatures');

  /// POST /sync/multiplayer-sessions
  /// Synchronizes multiplayer sessions.
  /// Parameters: { localSessions: List<Object>, lastSyncTimestamp: String? }
  static final String syncMultiplayerSessions =
  _buildUrl('/sync/multiplayer-sessions');

  /// POST /sync/notifications
  /// Synchronizes notifications.
  /// Parameters: { localNotifications: List<Object>, lastSyncTimestamp: String? }
  static final String syncNotifications = _buildUrl('/sync/notifications');

  /// POST /sync/pathogens
  /// Synchronizes pathogen data.
  /// Parameters: { localPathogens: List<Object>, lastSyncTimestamp: String? }
  static final String syncPathogens = _buildUrl('/sync/pathogens');

  /// POST /sync/researches
  /// Synchronizes research data.
  /// Parameters: { localResearches: List<Object>, lastSyncTimestamp: String? }
  static final String syncResearches = _buildUrl('/sync/researches');
}

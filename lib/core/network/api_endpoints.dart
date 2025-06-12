/// API endpoints for Immuno Warriors.
///
/// This file defines the API routes for communication with the backend.
/// Each endpoint includes the HTTP method, expected parameters, and description.
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
  /// GET /auth/verify-token
  /// Verifies the validity of the current JWT token.
  /// Parameters: None
  static final String verifyToken = _buildUrl('/api/auth/verify-token');

  /// POST /auth/sign-up
  /// Registers a new account.
  /// Parameters: { email: String, password: String, username: String }
  static final String signup = _buildUrl('/api/auth/sign-up');

  /// POST /auth/sign-in
  /// Logs in a user.
  /// Parameters: { email: String, password: String }
  static final String signin = _buildUrl('/api/auth/sign-in');

  /// POST /auth/refresh-token
  /// Refreshes the JWT token.
  /// Parameters: { refreshToken: String }
  static final String refreshToken = _buildUrl('/api/auth/refresh-token');

  /// POST /auth/sign-out
  /// Logs out the current user.
  /// Parameters: None
  static final String signout = _buildUrl('/api/auth/sign-out');

  /// --- User ---
  /// GET /user/profile
  /// Retrieves the current user's profile.
  /// Parameters: None
  static final String userProfile = _buildUrl('/api/user/profile');

  /// PUT /user/profile
  /// Updates the user's profile.
  /// Parameters: { username: String?, avatar: String? }
  static final String updateUserProfile = _buildUrl('/api/user/profile');

  /// POST /user/resources
  /// Adds resources to the user.
  /// Parameters: { credits: int?, energy: int? }
  static final String addUserResources = _buildUrl('/api/user/resources');

  /// GET /user/resources
  /// Retrieves the user's resources.
  /// Parameters: None
  static final String userResources = _buildUrl('/api/user/resources');

  /// POST /user/inventory
  /// Adds an item to the user's inventory.
  /// Parameters: { id: String, type: String, name: String, quantity: int }
  static final String addInventoryItem = _buildUrl('/api/user/inventory');

  /// DELETE /user/inventory/:itemId
  /// Removes an item from the user's inventory.
  /// Parameters: itemId (path)
  static String removeInventoryItem(String itemId) =>
      _buildUrl('/api/user/inventory/$itemId');

  /// GET /user/inventory
  /// Retrieves the user's inventory.
  /// Parameters: None
  static final String userInventory = _buildUrl('/api/user/inventory');

  /// PUT /user/settings
  /// Updates the user's settings.
  /// Parameters: { notifications: bool?, sound: bool?, language: String? }
  static final String updateUserSettings = _buildUrl('/api/user/settings');

  /// GET /user/settings
  /// Retrieves the user's settings.
  /// Parameters: None
  static final String userSettings = _buildUrl('/api/user/settings');

  /// DELETE /user
  /// Deletes the current user's account.
  /// Parameters: None
  static final String deleteUser = _buildUrl('/api/user');

  /// --- Combat ---
  /// POST /combat
  /// Starts a new combat session.
  // ignore: unintended_html_in_doc_comment
  /// Parameters: { baseId: String, antibodies: List<5String> }
  static final String combatStart = _buildUrl('/api/combat');

  /// POST /combat/:combatId/end
  /// Ends a combat session.
  /// Parameters: combatId (path), { outcome: String, stats: Object }
  static String combatEnd(String combatId) =>
      _buildUrl('/api/combat/$combatId/end');

  /// GET /combat/:combatId
  /// Retrieves a combat report.
  /// Parameters: combatId (path)
  static String combatReport(String combatId) =>
      _buildUrl('/api/combat/$combatId');

  /// GET /combat/history
  /// Retrieves the user's combat history.
  /// Parameters: None
  static final String combatHistory = _buildUrl('/api/combat/history');

  /// GET /combat/:combatId/chronicle
  /// Generates a combat chronicle.
  /// Parameters: combatId (path)
  static String combatChronicle(String combatId) =>
      _buildUrl('/api/combat/$combatId/chronicle');

  /// GET /combat/:combatId/advice
  /// Retrieves tactical advice for a combat.
  /// Parameters: combatId (path)
  static String combatAdvice(String combatId) =>
      _buildUrl('/api/combat/$combatId/advice');

  /// --- Research ---
  /// GET /research/tree
  /// Retrieves the research tree.
  /// Parameters: None
  static final String researchTree = _buildUrl('/api/research/tree');

  /// GET /research/progress
  /// Retrieves the user's research progress.
  /// Parameters: None
  static final String researchProgress = _buildUrl('/api/research/progress');

  /// POST /research/unlock
  /// Unlocks a research node.
  /// Parameters: { researchId: String }
  static final String researchUnlock = _buildUrl('/api/research/unlock');

  /// PUT /research/node/:researchId
  /// Updates progress for a research node.
  /// Parameters: researchId (path), { progress: int }
  static String researchNodeUrl(String researchId) =>
      _buildUrl('/api/research/node/$researchId');

  /// --- Threat Scanner ---
  /// POST /threat-scanner
  /// Adds a new threat.
  /// Parameters: { name: String, type: String, threatLevel: int, details: Object? }
  static final String addThreat = _buildUrl('/api/threat-scanner');

  /// GET /threat-scanner/:threatId
  /// Retrieves a specific threat.
  /// Parameters: threatId (path)
  static String getThreat(String threatId) =>
      _buildUrl('/api/threat-scanner/$threatId');

  /// GET /threat-scanner/scan/:targetId
  /// Scans a specific target for threats.
  /// Parameters: targetId (path)
  static String threatScannerScanUrl(String targetId) =>
      _buildUrl('/api/threat-scanner/scan/$targetId');

  /// --- Achievements ---
  /// GET /achievement
  /// Retrieves all achievements.
  /// Parameters: None
  static final String getAchievements = _buildUrl('/api/achievement');

  /// GET /achievement/:achievementId
  /// Retrieves a specific achievement.
  /// Parameters: achievementId (path)
  static String getAchievement(String achievementId) =>
      _buildUrl('/api/achievement/$achievementId');

  /// GET /achievement/user
  /// Retrieves the user's achievements.
  /// Parameters: None
  static final String userAchievements = _buildUrl('/api/achievement/user');

  /// GET /achievement/category/:category
  /// Retrieves achievements by category.
  /// Parameters: category (path)
  static String achievementsByCategory(String category) =>
      _buildUrl('/api/achievement/category/$category');

  /// POST /achievement
  /// Creates a new achievement (admin only).
  /// Parameters: { name: String, description: String, category: String, reward: Object }
  static final String createAchievement = _buildUrl('/api/achievement');

  /// PUT /achievement/:achievementId
  /// Updates an achievement (admin only).
  /// Parameters: achievementId (path), { name: String?, description: String?, reward: Object? }
  static String updateAchievement(String achievementId) =>
      _buildUrl('/api/achievement/$achievementId');

  /// DELETE /achievement/:achievementId
  /// Deletes an achievement (admin only).
  /// Parameters: achievementId (path)
  static String deleteAchievement(String achievementId) =>
      _buildUrl('/api/achievement/$achievementId');

  /// POST /achievement/unlock
  /// Unlocks an achievement for the user.
  /// Parameters: { achievementId: String }
  static final String unlockAchievement = _buildUrl('/api/achievement/unlock');

  /// PUT /achievement/:achievementId/progress
  /// Updates progress for an achievement.
  /// Parameters: achievementId (path), { progress: int }
  static String updateAchievementProgress(String achievementId) =>
      _buildUrl('/api/achievement/$achievementId/progress');

  /// POST /achievement/claim
  /// Claims a reward for an achievement.
  /// Parameters: { achievementId: String }
  static final String claimAchievementReward = _buildUrl(
    '/api/achievement/claim',
  );

  /// POST /achievement/:achievementId/notify
  /// Notifies the user of an unlocked achievement.
  /// Parameters: achievementId (path)
  static String notifyAchievementUnlocked(String achievementId) =>
      _buildUrl('/api/achievement/$achievementId/notify');

  /// --- Antibodies ---
  /// GET /antibody
  /// Retrieves all antibodies.
  /// Parameters: None
  static final String getAllAntibodies = _buildUrl('/api/antibody');

  /// POST /antibody
  /// Creates a new antibody.
  /// Parameters: { name: String, type: String, stats: Object }
  static final String createAntibody = _buildUrl('/api/antibody');

  /// GET /antibody/:antibodyId
  /// Retrieves a specific antibody.
  /// Parameters: antibodyId (path)
  static String getAntibody(String antibodyId) =>
      _buildUrl('/api/antibody/$antibodyId');

  /// GET /antibody/type/:type
  /// Retrieves antibodies by type.
  /// Parameters: type (path)
  static String antibodiesByType(String type) =>
      _buildUrl('/api/antibody/type/$type');

  /// PUT /antibody/:antibodyId
  /// Updates an antibody's stats.
  /// Parameters: antibodyId (path), { stats: Object }
  static String updateAntibodyStats(String antibodyId) =>
      _buildUrl('/api/antibody/$antibodyId');

  /// DELETE /antibody/:antibodyId
  /// Deletes an antibody.
  /// Parameters: antibodyId (path)
  static String deleteAntibody(String antibodyId) =>
      _buildUrl('/api/antibody/$antibodyId');

  /// PUT /antibody/:antibodyId/special-ability
  /// Assigns a special ability to an antibody.
  /// Parameters: antibodyId (path), { ability: String }
  static String assignSpecialAbility(String antibodyId) =>
      _buildUrl('/api/antibody/$antibodyId/special-ability');

  /// POST /antibody/:antibodyId/simulate
  /// Simulates the combat effect of an antibody.
  /// Parameters: antibodyId (path), { target: Object }
  static String simulateCombatEffect(String antibodyId) =>
      _buildUrl('/api/antibody/$antibodyId/simulate');

  /// --- Base Virale ---
  /// POST /base-virale
  /// Creates a new viral base.
  /// Parameters: { name: String, location: Object }
  static final String createBase = _buildUrl('/api/base-virale');

  /// GET /base-virale/:baseId
  /// Retrieves a specific base.
  /// Parameters: baseId (path)
  static String getBase(String baseId) => _buildUrl('/api/base-virale/$baseId');

  /// GET /base-virale/player
  /// Retrieves all bases owned by the player.
  /// Parameters: None
  static final String getPlayerBases = _buildUrl('/api/base-virale/player');

  /// GET /base-virale
  /// Retrieves all bases.
  /// Parameters: None
  static final String getAllBases = _buildUrl('/api/base-virale');

  /// PUT /base-virale/:baseId
  /// Updates a base.
  /// Parameters: baseId (path), { name: String?, location: Object? }
  static String updateBase(String baseId) =>
      _buildUrl('/api/base-virale/$baseId');

  /// DELETE /base-virale/:baseId
  /// Deletes a base.
  /// Parameters: baseId (path)
  static String deleteBase(String baseId) =>
      _buildUrl('/api/base-virale/$baseId');

  /// POST /base-virale/:baseId/pathogens
  /// Adds a pathogen to a base.
  /// Parameters: baseId (path), { pathogenId: String }
  static String addPathogen(String baseId) =>
      _buildUrl('/api/base-virale/$baseId/pathogens');

  /// DELETE /base-virale/:baseId/pathogens
  /// Removes a pathogen from a base.
  /// Parameters: baseId (path), { pathogenId: String }
  static String removePathogen(String baseId) =>
      _buildUrl('/api/base-virale/$baseId/pathogens');

  /// PUT /base-virale/:baseId/defenses
  /// Updates a base's defenses.
  /// Parameters: baseId (path), { defenses: Object }
  static String updateDefenses(String baseId) =>
      _buildUrl('/api/base-virale/$baseId/defenses');

  /// POST /base-virale/:baseId/level-up
  /// Levels up a base.
  /// Parameters: baseId (path)
  static String levelUpBase(String baseId) =>
      _buildUrl('/api/base-virale/$baseId/level-up');

  /// GET /base-virale/:baseId/validate
  /// Validates a base for combat.
  /// Parameters: baseId (path)
  static String validateForCombat(String baseId) =>
      _buildUrl('/api/base-virale/$baseId/validate');

  /// --- Gemini AI ---
  /// POST /gemini/chat
  /// Initiates a chat with Gemini AI.
  /// Parameters: { message: String }
  static final String geminiChat = _buildUrl('/api/gemini/chat');

  /// GET /gemini/combat-chronicle/:combatId
  /// Generates a combat chronicle using Gemini AI.
  /// Parameters: combatId (path)
  static String generateCombatChronicle(String combatId) =>
      _buildUrl('/api/gemini/combat-chronicle/$combatId');

  /// GET /gemini/tactical-advice/:combatId
  /// Retrieves tactical advice using Gemini AI.
  /// Parameters: combatId (path)
  static String getTacticalAdvice(String combatId) =>
      _buildUrl('/api/gemini/tactical-advice/$combatId');

  /// GET /gemini/research-description/:researchId
  /// Generates a research description using Gemini AI.
  /// Parameters: researchId (path)
  static String generateResearchDescription(String researchId) =>
      _buildUrl('/api/gemini/research-description/$researchId');

  /// GET /gemini/base-description/:baseId
  /// Generates a base description using Gemini AI.
  /// Parameters: baseId (path)
  static String generateBaseDescription(String baseId) =>
      _buildUrl('/api/gemini/base-description/$baseId');

  /// GET /gemini/stored-responses
  /// Retrieves stored Gemini AI responses.
  /// Parameters: None
  static final String getStoredGeminiResponses = _buildUrl(
    '/api/gemini/stored-responses',
  );

  /// --- Inventory ---
  /// POST /inventory
  /// Adds an item to the inventory.
  /// Parameters: { id: String, type: String, name: String, quantity: int }
  static final String addInventory = _buildUrl('/api/inventory');

  /// GET /inventory/:itemId
  /// Retrieves a specific inventory item.
  /// Parameters: itemId (path)
  static String getInventoryItem(String itemId) =>
      _buildUrl('/api/inventory/$itemId');

  /// GET /inventory
  /// Retrieves the user's inventory.
  /// Parameters: None
  static final String getUserInventory = _buildUrl('/api/inventory');

  /// PUT /inventory/:itemId
  /// Updates an inventory item.
  /// Parameters: itemId (path), { quantity: int?, name: String? }
  static String updateInventoryItem(String itemId) =>
      _buildUrl('/api/inventory/$itemId');

  /// DELETE /inventory/:itemId
  /// Deletes an inventory item.
  /// Parameters: itemId (path)
  static String deleteInventoryItem(String itemId) =>
      _buildUrl('/api/inventory/$itemId');

  /// --- Leaderboard ---
  /// POST /leaderboard/score
  /// Updates the user's score.
  /// Parameters: { score: int, category: String }
  static final String updateLeaderboardScore = _buildUrl(
    '/api/leaderboard/score',
  );

  /// GET /leaderboard/:category
  /// Retrieves the leaderboard for a category.
  /// Parameters: category (path)
  static String getLeaderboard(String category) =>
      _buildUrl('/api/leaderboard/$category');

  /// GET /leaderboard/:category/rank
  /// Retrieves the user's rank in a category.
  /// Parameters: category (path)
  static String getUserRank(String category) =>
      _buildUrl('/api/leaderboard/$category/rank');

  /// --- Memory Signatures ---
  /// POST /memory
  /// Adds a new memory signature.
  /// Parameters: { signature: Object }
  static final String addMemorySignature = _buildUrl('/api/memory');

  /// GET /memory
  /// Retrieves the user's memory signatures.
  /// Parameters: None
  static final String getUserMemorySignatures = _buildUrl('/api/memory');

  /// GET /memory/:signatureId/validate
  /// Validates a memory signature.
  /// Parameters: signatureId (path)
  static String validateMemorySignature(String signatureId) =>
      _buildUrl('/api/memory/$signatureId/validate');

  /// DELETE /memory/expired
  /// Clears expired memory signatures.
  /// Parameters: None
  static final String clearExpiredSignatures = _buildUrl('/api/memory/expired');

  /// --- Multiplayer ---
  /// POST /multiplayer
  /// Creates a new multiplayer session.
  /// Parameters: { sessionConfig: Object }
  static final String createMultiplayerSession = _buildUrl('/api/multiplayer');

  /// POST /multiplayer/:sessionId/join
  /// Joins a multiplayer session.
  /// Parameters: sessionId (path)
  static String joinMultiplayerSession(String sessionId) =>
      _buildUrl('/api/multiplayer/$sessionId/join');

  /// GET /multiplayer/:sessionId/status
  /// Retrieves the status of a multiplayer session.
  /// Parameters: sessionId (path)
  static String getSessionStatus(String sessionId) =>
      _buildUrl('/api/multiplayer/$sessionId/status');

  /// GET /multiplayer
  /// Retrieves the user's multiplayer sessions.
  /// Parameters: None
  static final String getUserSessions = _buildUrl('/api/multiplayer');

  /// --- Notifications ---
  /// POST /notification
  /// Creates a new notification.
  /// Parameters: { message: String, type: String }
  static final String createNotification = _buildUrl('/api/notification');

  /// GET /notification
  /// Retrieves the user's notifications.
  /// Parameters: None
  static final String getNotifications = _buildUrl('/api/notification');

  /// PUT /notification/:notificationId/read
  /// Marks a notification as read.
  /// Parameters: notificationId (path)
  static String markNotificationAsRead(String notificationId) =>
      _buildUrl('/api/notification/$notificationId/read');

  /// DELETE /notification/:notificationId
  /// Deletes a notification.
  /// Parameters: notificationId (path)
  static String deleteNotification(String notificationId) =>
      _buildUrl('/api/notification/$notificationId');

  /// PUT /notification/batch/read
  /// Marks multiple notifications as read.
  /// Parameters: { notificationIds: List<String> }
  static final String markBatchNotificationsAsRead = _buildUrl(
    '/api/notification/batch/read',
  );

  /// DELETE /notification/batch
  /// Deletes multiple notifications.
  /// Parameters: { notificationIds: List<String> }
  static final String deleteBatchNotifications = _buildUrl(
    '/api/notification/batch',
  );

  /// --- Pathogens ---
  /// POST /pathogen
  /// Creates a new pathogen.
  /// Parameters: { name: String, type: String, rarity: String, stats: Object }
  static final String createPathogen = _buildUrl('/api/pathogen');

  /// GET /pathogen/type/:type
  /// Retrieves pathogens by type.
  /// Parameters: type (path)
  static String getPathogensByType(String type) =>
      _buildUrl('/api/pathogen/type/$type');

  /// GET /pathogen/rarity/:rarity
  /// Retrieves pathogens by rarity.
  /// Parameters: rarity (path)
  static String getPathogensByRarity(String rarity) =>
      _buildUrl('/api/pathogen/rarity/$rarity');

  /// PUT /pathogen/:pathogenId/stats
  /// Updates a pathogen's stats.
  /// Parameters: pathogenId (path), { stats: Object }
  static String updatePathogenStats(String pathogenId) =>
      _buildUrl('/api/pathogen/$pathogenId/stats');

  /// GET /pathogen
  /// Retrieves all pathogens.
  /// Parameters: None
  static final String getAllPathogens = _buildUrl('/api/pathogen');

  /// DELETE /pathogen/:pathogenId
  /// Deletes a pathogen.
  /// Parameters: pathogenId (path)
  static String deletePathogen(String pathogenId) =>
      _buildUrl('/api/pathogen/$pathogenId');

  /// --- Progression ---
  /// GET /progression
  /// Retrieves the user's progression.
  /// Parameters: None
  static final String getProgression = _buildUrl('/api/progression');

  /// POST /progression/xp
  /// Adds XP to the user's progression.
  /// Parameters: { xp: int }
  static final String addXP = _buildUrl('/api/progression/xp');

  /// POST /progression/mission/:missionId
  /// Completes a mission for the user.
  /// Parameters: missionId (path)
  static String completeMission(String missionId) =>
      _buildUrl('/api/progression/mission/$missionId');

  /// --- Sync ---
  /// POST /sync/user-data
  /// Synchronizes user data.
  /// Parameters: { localData: Object, lastSyncTimestamp: String? }
  static final String syncUserData = _buildUrl('/api/sync/user-data');

  /// POST /sync/inventory
  /// Synchronizes inventory data.
  /// Parameters: { localItems: List<Object>, lastSyncTimestamp: String? }
  static final String syncInventory = _buildUrl('/api/sync/inventory');

  /// POST /sync/threats
  /// Synchronizes threat data.
  /// Parameters: { localThreats: List<Object>, lastSyncTimestamp: String? }
  static final String syncThreats = _buildUrl('/api/sync/threats');

  /// POST /sync/memory-signatures
  /// Synchronizes memory signatures.
  /// Parameters: { localSignatures: List<Object>, lastSyncTimestamp: String? }
  static final String syncMemorySignatures = _buildUrl(
    '/api/sync/memory-signatures',
  );

  /// POST /sync/multiplayer-sessions
  /// Synchronizes multiplayer sessions.
  /// Parameters: { localSessions: List<Object>, lastSyncTimestamp: String? }
  static final String syncMultiplayerSessions = _buildUrl(
    '/api/sync/multiplayer-sessions',
  );

  /// POST /sync/notifications
  /// Synchronizes notifications.
  /// Parameters: { localNotifications: List<Object>, lastSyncTimestamp: String? }
  static final String syncNotifications = _buildUrl('/api/sync/notifications');

  /// POST /sync/pathogens
  /// Synchronizes pathogen data.
  /// Parameters: { localPathogens: List<Object>, lastSyncTimestamp: String? }
  static final String syncPathogens = _buildUrl('/api/sync/pathogens');

  /// POST /sync/researches
  /// Synchronizes research data.
  /// Parameters: { localResearches: List<Object>, lastSyncTimestamp: String? }
  static final String syncResearches = _buildUrl('/api/sync/researches');
}

/// Methods to implement in the frontend with their parameters.
/// These methods correspond to the API endpoints and should be implemented
/// in a service class (e.g., ApiService) to handle HTTP requests.

/// Authentication
/// - verifyToken(): Future<void> - Verifies the JWT token.
/// - signup(email: String, password: String, username: String): Future<void> - Registers a new user.
/// - signin(email: String, password: String): Future<void> - Logs in a user.
/// - refreshToken(refreshToken: String): Future<void> - Refreshes the JWT token.
/// - signout(): Future<void> - Logs out the user.

/// User
/// - getUserProfile(): Future<Map> - Retrieves the user's profile.
/// - updateUserProfile(username: String?, avatar: String?): Future<void> - Updates the user's profile.
/// - addUserResources(credits: int?, energy: int?): Future<void> - Adds resources.
/// - getUserResources(): Future<Map> - Retrieves resources.
/// - addInventoryItem(id: String, type: String, name: String, quantity: int): Future<void> - Adds an inventory item.
/// - removeInventoryItem(itemId: String): Future<void> - Removes an inventory item.
/// - getUserInventory(): Future<List> - Retrieves the inventory.
/// - updateUserSettings(notifications: bool?, sound: bool?, language: String?): Future<void> - Updates settings.
/// - getUserSettings(): Future<Map> - Retrieves settings.
/// - deleteUser(): Future<void> - Deletes the user account.

/// Combat
/// - startCombat(baseId: String, antibodies: List<String>): Future<void> - Starts a combat.
/// - endCombat(combatId: String, outcome: String, stats: Map): Future<void> - Ends a combat.
/// - getCombatReport(combatId: String): Future<Map> - Retrieves a combat report.
/// - getCombatHistory(): Future<List> - Retrieves combat history.
/// - generateCombatChronicle(combatId: String): Future<String> - Generates a combat chronicle.
/// - getCombatAdvice(combatId: String): Future<String> - Retrieves tactical advice.

/// Research
/// - getResearchTree(): Future<List> - Retrieves the research tree.
/// - getResearchProgress(): Future<Map> - Retrieves research progress.
/// - unlockResearch(researchId: String): Future<void> - Unlocks a research node.
/// - updateResearchProgress(researchId: String, progress: int): Future<void> - Updates research progress.

/// Threat Scanner
/// - addThreat(name: String, type: String, threatLevel: int, details: Map?): Future<void> - Adds a threat.
/// - getThreat(threatId: String): Future<Map> - Retrieves a threat.
/// - scanThreat(targetId: String): Future<Map> - Scans a target for threats.

/// Achievements
/// - getAchievements(): Future<List> - Retrieves all achievements.
/// - getAchievement(achievementId: String): Future<Map> - Retrieves an achievement.
/// - getUserAchievements(): Future<List> - Retrieves user achievements.
/// - getAchievementsByCategory(category: String): Future<List> - Retrieves achievements by category.
/// - createAchievement(name: String, description: String, category: String, reward: Map): Future<void> - Creates an achievement.
/// - updateAchievement(achievementId: String, name: String?, description: String?, reward: Map?): Future<void> - Updates an achievement.
/// - deleteAchievement(achievementId: String): Future<void> - Deletes an achievement.
/// - unlockAchievement(achievementId: String): Future<void> - Unlocks an achievement.
/// - updateAchievementProgress(achievementId: String, progress: int): Future<void> - Updates achievement progress.
/// - claimAchievementReward(achievementId: String): Future<void> - Claims an achievement reward.
/// - notifyAchievementUnlocked(achievementId: String): Future<void> - Notifies an unlocked achievement.

/// Antibodies
/// - getAllAntibodies(): Future<List> - Retrieves all antibodies.
/// - createAntibody(name: String, type: String, stats: Map): Future<void> - Creates an antibody.
/// - getAntibody(antibodyId: String): Future<Map> - Retrieves an antibody.
/// - getAntibodiesByType(type: String): Future<List> - Retrieves antibodies by type.
/// - updateAntibodyStats(antibodyId: String, stats: Map): Future<void> - Updates antibody stats.
/// - deleteAntibody(antibodyId: String): Future<void> - Deletes an antibody.
/// - assignSpecialAbility(antibodyId: String, ability: String): Future<void> - Assigns a special ability.
/// - simulateCombatEffect(antibodyId: String, target: Map): Future<Map> - Simulates combat effect.

/// Base Virale
/// - createBase(name: String, location: Map): Future<void> - Creates a viral base.
/// - getBase(baseId: String): Future<Map> - Retrieves a base.
/// - getPlayerBases(): Future<List> - Retrieves player bases.
/// - getAllBases(): Future<List> - Retrieves all bases.
/// - updateBase(baseId: String, name: String?, location: Map?): Future<void> - Updates a base.
/// - deleteBase(baseId: String): Future<void> - Deletes a base.
/// - addPathogen(baseId: String, pathogenId: String): Future<void> - Adds a pathogen to a base.
/// - removePathogen(baseId: String, pathogenId: String): Future<void> - Removes a pathogen.
/// - updateDefenses(baseId: String, defenses: Map): Future<void> - Updates base defenses.
/// - levelUpBase(baseId: String): Future<void> - Levels up a base.
/// - validateForCombat(baseId: String): Future<bool> - Validates a base for combat.

/// Gemini AI
/// - geminiChat(message: String): Future<String> - Initiates a chat with Gemini AI.
/// - generateCombatChronicle(combatId: String): Future<String> - Generates a combat chronicle.
/// - getTacticalAdvice(combatId: String): Future<String> - Retrieves tactical advice.
/// - generateResearchDescription(researchId: String): Future<String> - Generates a research description.
/// - generateBaseDescription(baseId: String): Future<String> - Generates a base description.
/// - getStoredGeminiResponses(): Future<List> - Retrieves stored responses.

/// Inventory
/// - addInventory(id: String, type: String, name: String, quantity: int): Future<void> - Adds an inventory item.
/// - getInventoryItem(itemId: String): Future<Map> - Retrieves an inventory item.
/// - getUserInventory(): Future<List> - Retrieves the inventory.
/// - updateInventoryItem(itemId: String, quantity: int?, name: String?): Future<void> - Updates an item.
/// - deleteInventoryItem(itemId: String): Future<void> - Deletes an item.

/// Leaderboard
/// - updateLeaderboardScore(score: int, category: String): Future<void> - Updates the score.
/// - getLeaderboard(category: String): Future<List> - Retrieves the leaderboard.
/// - getUserRank(category: String): Future<Map> - Retrieves the user's rank.

/// Memory Signatures
/// - addMemorySignature(signature: Map): Future<void> Future<void> - a new Adds a memory signature.
/// - getUserMemorySignatures(userId: String): Future<List> - Retrieves the user's memory signatures.
/// - validateMemorySignature(signatureId: String): Future<bool> - Validates a memory signature.
/// - clearExpiredSignatures(): Future<void> - Clears expired signatures.

/// Multiplayer
/// - createMultiplayerSession(sessionId: Map): Future<void> Configurable - Creates a multiplayer session.
/// - joinMultiplayerSession(sessionId): Future<void> String): Join - a Joins a multiplayer session.
/// - getMultiplayerStatus: Future<void>(sessionId): String): Future<Map> Get - the Retrieves status of a multiplayer session.
/// - getUserMultiplayerSessions(): Future<List> - Retrieves the user's multiplayer sessions.

/// Notifications
/// - createNotification(message: String, type: String): Future<void> - Creates a new notification.
/// - getUserNotifications(): Future<void> Future<List> Retrieves - the user's all notifications.
/// - markAsNotificationRead(notificationId): String): Future<void> a - Marks a notification as read.
/// - deleteUserNotification(notificationId): String): Future<void> Deletes a notification.
/// - markBatchAsNotificationsRead(notificationIds: List<String>)): Future<void> Future<void> multiple - Marks multiple notifications as read.
/// - deleteBatchNotifications(notificationIds: List<String>): Future<void> - Deletes multiple notifications.

/// Pathogens
/// - createPathogen(name: String, type: String, rarity: String, stats: Map): Future<void> - Creates a new pathogen.
/// - getPathogensByType(type: String): Future<List> - Retrieves pathogens by type.
/// - getPathogensByRarity(rarity): String): Future<List> - Retrieves pathogens by rarity.
/// - updatePathogenStats(pathogenId: String, stats: Map): Future<void> - Updates a pathogen's stats.
/// - getAllPathogens(): Future<void> Future<List> - Retrieves all pathogens.
/// - deletePathogen(pathogenId: String): Future<void> - Deletes a pathogen.

/// Progression
/// - getUserProgression(): Future<void> Map> Progressions - Retrieves the user's progression.
/// - addUserXP(xp: int): Future<void> - Adds XP to the user's progress.
/// - completeUserMission(missionId): String): Future<void> - Complete Completes a mission.

/// Synchronization
/// - synchronizeUserData(localData: Map, lastSyncTimestamp: String?): Future<Map> - Synchronizes user data.
/// - synchronizeInventory(localItems: List, lastSyncTimestamp: String?): Future<Map> - Synchronizes inventory.
/// - synchronizeThreats(localThreats: List, lastSyncTimestamp): String?): Future<Map> - Synchronizes threats.
/// - synchronizeMemorySignatures(localSignatures: List, lastSyncTimestamp: String?): Future<Map> - Synchronizes memory signatures.
/// - synchronizeMultiplayerSessions(localSessions: List, lastSyncTimestamp): String?): Future<Map> - Synchronizes multiplayer sessions.
/// - synchronizeNotifications(localNotifications: List, lastSyncTimestamp: String?): Future<Map> - Synchronizes notifications.
/// - synchronizePathogens(localPathogens: List, lastSyncTimestamp): String?): Future<Map> - Synchronizes pathogens.
/// - synchronizeResearches(localResearches: List, lastSyncTimestamp: String?): Future<Map> - Synchronizes researches.

/// Route names for Immuno Warriors navigation.
///
/// Defines named routes for consistent navigation across the app.
class RouteNames {
  /// --- Initial Routes ---
  static const String splash = 'splash';
  static const String home = 'home';

  /// --- Authentication Routes ---
  static const String profileAuthOptions = 'profileAuthOptions';
  static const String login = 'login';
  static const String register = 'register';
  static const String profileAuth =
      'profileAuth'; // Parameterized: /profileAuth/:userId
  static const String loginFromRegister = 'loginFromRegister';
  static const String registerFromLogin = 'registerFromLogin';

  /// --- Main Feature Routes ---
  static const String dashboard = 'dashboard';
  static const String combat = 'combat';
  static const String research = 'research';
  static const String bioForge = 'bioForge';
  static const String warArchive = 'warArchive';
  static const String threatScanner = 'threatScanner';
  static const String gemini = 'gemini';

  /// --- Utility Routes ---
  static const String settings = 'settings';
  static const String help = 'help';

  /// --- Future Feature Routes ---
  static const String leaderboard = 'leaderboard';
  static const String multiplayer =
      'multiplayer'; // Parameterized: /multiplayer/:gameId
  static const String researchNode =
      'researchNode'; // Parameterized: /research/:nodeId
}

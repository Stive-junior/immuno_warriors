// Exceptions principales pour Immuno Warriors.
//
// Ce fichier définit les exceptions personnalisées pour gérer les erreurs liées à l'API,
// à l'authentification, aux fonctionnalités du jeu et au stockage local.
// Chaque exception inclut un message descriptif et, le cas échéant, des détails supplémentaires.

/// Exception de base pour les erreurs API.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException(this.message, {this.statusCode, this.error});

  @override
  String toString() =>
      'ApiException: $message (Status: $statusCode, Error: $error)';
}

/// Exception pour les erreurs de validation des données API.
class ApiValidationException extends ApiException {
  ApiValidationException(super.message, {super.statusCode, super.error});
}

/// Exception pour les données locales obsolètes.
class StaleDataException extends ApiException {
  StaleDataException() : super('Données locales obsolètes.');
}

/// Exception de base pour les erreurs d'authentification.
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception pour un e-mail non vérifié.
class EmailNotVerifiedException extends AuthException {
  EmailNotVerifiedException()
    : super(
        'Votre e-mail n\'a pas été vérifié. Veuillez vérifier votre boîte de réception.',
      );
}

/// Exception pour des identifiants invalides.
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
    : super('Identifiants invalides. Veuillez vérifier vos informations.');
}

/// Exception pour un mot de passe faible.
class WeakPasswordException extends AuthException {
  WeakPasswordException()
    : super('Le mot de passe est trop faible. Utilisez au moins 6 caractères.');
}

/// Exception pour un utilisateur non trouvé.
class UserNotFoundException extends AuthException {
  UserNotFoundException()
    : super('Utilisateur non trouvé. Veuillez vérifier votre e-mail.');
}

/// Exception pour un utilisateur déjà existant.
class UserAlreadyExistsException extends AuthException {
  UserAlreadyExistsException()
    : super('Cet utilisateur existe déjà. Essayez un autre e-mail.');
}

/// Exception pour une erreur de connexion sociale.
class SocialLoginException extends AuthException {
  SocialLoginException(String provider)
    : super('Échec de la connexion avec $provider. Veuillez réessayer.');
}

/// Exception de base pour les erreurs liées au combat.
class CombatException implements Exception {
  final String message;

  CombatException(this.message);

  @override
  String toString() => 'CombatException: $message';
}

/// Exception pour une équipe de combat invalide.
class InvalidSquadException extends CombatException {
  InvalidSquadException()
    : super(
        'L\'équipe de combat est invalide. Vérifiez la taille ou la composition.',
      );
}

/// Exception pour des ressources insuffisantes en combat.
class InsufficientCombatResourcesException extends CombatException {
  InsufficientCombatResourcesException()
    : super('Ressources insuffisantes pour lancer le combat.');
}

/// Exception de base pour les erreurs liées à BioForge.
class BioForgeException implements Exception {
  final String message;

  BioForgeException(this.message);

  @override
  String toString() => 'BioForgeException: $message';
}

/// Exception pour une configuration BioForge invalide.
class InvalidBioForgeConfigException extends BioForgeException {
  InvalidBioForgeConfigException()
    : super(
        'Configuration BioForge invalide. Vérifiez les slots ou les ressources.',
      );
}

/// Exception pour des ressources insuffisantes dans BioForge.
class InsufficientBioForgeResourcesException extends BioForgeException {
  InsufficientBioForgeResourcesException()
    : super('Ressources insuffisantes pour déployer ou fabriquer.');
}

/// Exception de base pour les erreurs liées à la recherche.
class ResearchException implements Exception {
  final String message;

  ResearchException(this.message);

  @override
  String toString() => 'ResearchException: $message';
}

/// Exception pour un nœud de recherche non déblocable.
class ResearchNodeLockedException extends ResearchException {
  ResearchNodeLockedException()
    : super('Ce nœud de recherche n\'est pas encore déblocable.');
}

/// Exception pour des points de recherche insuffisants.
class InsufficientResearchPointsException extends ResearchException {
  InsufficientResearchPointsException()
    : super('Points de recherche insuffisants pour débloquer ce nœud.');
}

/// Exception de base pour les erreurs liées au scanner de menaces.
class ThreatScannerException implements Exception {
  final String message;

  ThreatScannerException(this.message);

  @override
  String toString() => 'ThreatScannerException: $message';
}

/// Exception pour un échec de scan.
class ScanFailedException extends ThreatScannerException {
  ScanFailedException()
    : super('Échec du scan des menaces. Veuillez réessayer.');
}

/// Exception de base pour les erreurs liées au mode multijoueur.
class MultiplayerException implements Exception {
  final String message;

  MultiplayerException(this.message);

  @override
  String toString() => 'MultiplayerException: $message';
}

/// Exception pour une session multijoueur introuvable.
class SessionNotFoundException extends MultiplayerException {
  SessionNotFoundException()
    : super('Session multijoueur non trouvée. Vérifiez l\'ID de la session.');
}

/// Exception pour une session multijoueur pleine.
class SessionFullException extends MultiplayerException {
  SessionFullException()
    : super('La session multijoueur est pleine. Essayez une autre session.');
}

/// Exception de base pour les erreurs liées aux archives de guerre.
class WarArchiveException implements Exception {
  final String message;

  WarArchiveException(this.message);

  @override
  String toString() => 'WarArchiveException: $message';
}

/// Exception pour un rapport de combat introuvable.
class CombatReportNotFoundException extends WarArchiveException {
  CombatReportNotFoundException()
    : super('Rapport de combat non trouvé dans les archives.');
}

/// Exception de base pour les erreurs liées à Gemini AI.
class GeminiException implements Exception {
  final String message;

  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}

/// Exception pour une requête Gemini invalide.
class InvalidGeminiRequestException extends GeminiException {
  InvalidGeminiRequestException()
    : super('Requête Gemini invalide. Vérifiez les paramètres.');
}

/// Exception de base pour les erreurs de stockage local.
class LocalStorageException implements Exception {
  final String message;

  LocalStorageException(this.message);

  @override
  String toString() => 'LocalStorageException: $message';
}

/// Exception pour une initialisation échouée du stockage local.
class LocalStorageInitException extends LocalStorageException {
  LocalStorageInitException()
    : super('Échec de l\'initialisation du stockage local.');
}

/// Exception pour une erreur de lecture du stockage local.
class LocalStorageReadException extends LocalStorageException {
  LocalStorageReadException()
    : super('Erreur lors de la lecture des données locales.');
}

/// Exception pour une erreur d'écriture dans le stockage local.
class LocalStorageWriteException extends LocalStorageException {
  LocalStorageWriteException()
    : super('Erreur lors de l\'écriture des données locales.');
}

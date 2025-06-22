// Exceptions réseau pour Immuno Warriors.
//
// Ce fichier définit les exceptions personnalisées pour gérer les erreurs liées au réseau,
// telles que l'absence de connexion, les serveurs injoignables ou les délais d'expiration.

/// Exception de base pour les erreurs réseau.
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception pour l'absence de connexion Internet.
class NoInternetException extends NetworkException {
  NoInternetException()
    : super(
        'Aucune connexion Internet disponible. Veuillez vérifier votre connexion.',
      );
}

/// Exception pour un serveur injoignable.
class ServerUnreachableException extends NetworkException {
  ServerUnreachableException()
    : super(
        'Le serveur est injoignable. Veuillez vérifier votre connexion ou changer l\'URL de l\'API.',
      );
}

/// Exception pour une requête réseau qui a expiré.
class TimeoutException extends NetworkException {
  TimeoutException()
    : super(
        'La requête a expiré. Veuillez vérifier votre connexion et réessayer.',
      );
}

/// Exception pour une réponse serveur inattendue.
class UnexpectedResponseException extends NetworkException {
  UnexpectedResponseException()
    : super(
        'Réponse inattendue du serveur. Veuillez réessayer ou contacter le support.',
      );
}

/// Exception pour une requête réseau non autorisée.
class UnauthorizedRequestException extends NetworkException {
  UnauthorizedRequestException()
    : super(
        'Requête non autorisée. Veuillez vérifier vos identifiants ou reconnectez-vous.',
      );
}

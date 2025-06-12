class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class NoInternetException extends NetworkException {
  NoInternetException()
    : super(
        'Aucune connexion Internet disponible. Veuillez vérifier votre connexion.',
      );
}

class ServerUnreachableException extends NetworkException {
  ServerUnreachableException()
    : super(
        'Le serveur est injoignable. Veuillez vérifier votre connexion ou changer l\'URL de l\'API.',
      );
}

class StaleDataException extends NetworkException {
  StaleDataException()
    : super(
        'Les données locales ne sont pas à jour. Veuillez vous connecter pour synchroniser.',
      );
}

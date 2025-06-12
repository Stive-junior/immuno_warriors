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

/// Exception pour les données locales obsolètes.
class StaleDataException extends ApiException {
  StaleDataException() : super('Données locales obsolètes.');
}

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  AppException(this.message, {this.statusCode, this.error});

  @override
  String toString() =>
      'ApiException: $message (Status: $statusCode, Error: $error)';
}

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart' show LogEvent;

class AppLogger {
  static final _logger = log.Logger(
    printer:
        kDebugMode
            ? CustomPrettyPrinter()
            : log.SimplePrinter(printTime: false), // Temps géré manuellement
    filter: kDebugMode ? log.DevelopmentFilter() : ProductionFilter(),
    output: log.ConsoleOutput(),
  );

  // Contexte pour les logs (ex. userId, sessionId)
  static Map<String, dynamic> _context = {};

  /// Définit le contexte des logs (ex. userId, sessionId).
  static void setContext({String? userId, String? sessionId}) {
    _context = {
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  /// Log un message de débogage.
  static void debug(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(
      _formatMessage(message),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log un message d'information.
  static void info(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(
      _formatMessage(message),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log un message d'avertissement.
  static void warning(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(
      _formatMessage(message),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log un message d'erreur.
  static void error(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      _formatMessage(message),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log un message fatal.
  static void fatal(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(
      _formatMessage(message),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Formate le message avec timestamp et contexte.
  static String _formatMessage(dynamic message) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss', 'fr_FR');
    final formattedMessage = StringBuffer();
    formattedMessage.write('[${dateFormat.format(DateTime.now())}] ');
    if (_context.isNotEmpty) {
      formattedMessage.write('Contexte: ${_context.toString()} ');
    }
    formattedMessage.write(message.toString());
    return formattedMessage.toString();
  }
}

/// Filtre pour la production (ignore les logs de débogage).
class ProductionFilter extends log.LogFilter {
  @override
  bool shouldLog(log.LogEvent event) {
    return event.level.index >= log.Level.info.index;
  }
}

/// Imprimante personnalisée pour un format lisible.
class CustomPrettyPrinter extends log.PrettyPrinter {
  CustomPrettyPrinter()
    : super(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      );

  @override
  List<String> log(LogEvent event) {
    final lines = super.log(event);
    return lines.map((line) => '[ImmunoWarriors] $line').toList();
  }
}

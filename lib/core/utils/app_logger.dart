import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart' show LogEvent;

// Initialisation des données de locale pour 'fr_FR'
void initializeLogger() async {
  await initializeDateFormatting('fr_FR', null);
}

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
      _formatMessage(message, stackTrace),
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
      _formatMessage(message, stackTrace),
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
      _formatMessage(message, stackTrace),
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
      _formatMessage(message, stackTrace),
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
      _formatMessage(message, stackTrace),
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Formate le message avec timestamp, contexte et nom du fichier.
  static String _formatMessage(dynamic message, StackTrace? stackTrace) {
    final timestamp = DateTime.now();
    String formattedTime;
    try {
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss', 'fr_FR');
      formattedTime = dateFormat.format(timestamp);
    } catch (e) {
      formattedTime = timestamp.toIso8601String(); // Fallback
      _logger.w('Échec du formatage du timestamp : $e');
    }

    final formattedMessage = StringBuffer();
    formattedMessage.write('[$formattedTime] ');

    // Ajout du nom du fichier
    if (stackTrace != null) {
      final fileInfo = _extractFileInfo(stackTrace);
      if (fileInfo != null) {
        formattedMessage.write('[${fileInfo['file']}:${fileInfo['line']}] ');
      }
    }

    if (_context.isNotEmpty) {
      formattedMessage.write('Contexte: ${_context.toString()} ');
    }
    formattedMessage.write(message.toString());
    return formattedMessage.toString();
  }

  /// Extrait le nom du fichier et la ligne depuis la StackTrace.
  static Map<String, dynamic>? _extractFileInfo(StackTrace stackTrace) {
    try {
      final stackLines = stackTrace.toString().split('\n');
      // Cherche la première ligne pertinente (après AppLogger)
      for (var line in stackLines) {
        if (line.isNotEmpty && !line.contains('app_logger.dart')) {
          final match = RegExp(r'\(([^:]+):(\d+):\d+\)').firstMatch(line);
          if (match != null) {
            final filePath = match.group(1)!;
            final fileName = filePath.split('/').last;
            final lineNumber = match.group(2)!;
            return {'file': fileName, 'line': lineNumber};
          }
          break;
        }
      }
    } catch (e) {
      _logger.w('Échec de l\'extraction du fichier depuis StackTrace : $e');
    }
    return null;
  }
}

/// Filtre pour la production (ignore les logs de débogage).
class ProductionFilter extends log.LogFilter {
  @override
  bool shouldLog(LogEvent event) {
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


import 'package:intl/intl.dart';

/// Provides utility functions for date and time manipulation.
class DateUtils {
  /// Formats a DateTime object into a human-readable string.
  static String formatDateTime(DateTime dateTime, {String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateTime.toString();
    }
  }

  /// Calculates the time difference between two DateTime objects and returns it in a readable format.
  static String timeAgo(DateTime past, {bool numericDates = true}) {
    final now = DateTime.now();
    final difference = now.difference(past);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return numericDates ? '$years an(s) ago' : (years == 1 ? 'Last year' : '$years years ago');
    }
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return numericDates ? '$months month(s) ago' : (months == 1 ? 'Last month' : '$months months ago');
    }
    if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return numericDates ? '$weeks week(s) ago' : (weeks == 1 ? 'Last week' : '$weeks weeks ago');
    }
    if (difference.inDays >= 1) {
      return numericDates ? '${difference.inDays} day(s) ago' : (difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago');
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours} hour(s) ago';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute(s) ago';
    }
    return 'Just now';
  }

  /// Parses a string into a DateTime object, returning null if parsing fails.
  static DateTime? tryParseDate(String dateString, {List<String>? formats}) {
    if (formats != null && formats.isNotEmpty) {
      for (final format in formats) {
        try {
          return DateFormat(format).parseStrict(dateString);
        } catch (e) {
          // Try the next format
        }
      }
      return null;
    } else {
      return DateTime.tryParse(dateString);
    }
  }
}
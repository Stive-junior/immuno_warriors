import 'package:intl/intl.dart';


extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Parses the string to an integer, returning null if parsing fails.
  int? get tryParseInt {
    try {
      return int.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Parses the string to a double, returning null if parsing fails.
  double? get tryParseDouble {
    try {
      return double.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Formats a date string to a more readable format.
  String formatDate({String pattern = 'yyyy-MM-dd'}) {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return this; // Return original string if parsing fails
    }
  }

  /// Checks if the string is a valid email address.
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(this);
  }

  /// Checks if the string is a valid password (at least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character).
  bool get isValidPassword {
    if (length < 8) return false;

    final hasUpper = RegExp(r'[A-Z]').hasMatch(this);
    final hasLower = RegExp(r'[a-z]').hasMatch(this);
    final hasDigit = RegExp(r'[0-9]').hasMatch(this);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Reverses the string.
  String get reverse => split('').reversed.join();

  /// Checks if the string contains only digits.
  bool get isDigitsOnly => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Truncates the string to a maximum length and adds an ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Converts a string to title case (e.g., "hello world" to "Hello World").
  String get titleCase {
    if (isEmpty) {
      return this;
    }
    return toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Checks if the string is a valid URL.
  bool get isValidUrl {
    try {
      // Using Uri.parse for more reliable URL validation
      final uri = Uri.parse(this);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  /// Formats a number with commas (e.g., 1000 to 1,000).
  String formatNumber() {
    try {
      final number = num.parse(this);
      return NumberFormat.decimalPattern().format(number);
    } catch (e) {
      return this;
    }
  }

  /// Checks if the string is a valid phone number (international format).
  bool get isValidPhone {
    final phoneRegExp = RegExp(
      r'^\+?[0-9]{8,15}$',
    );
    return phoneRegExp.hasMatch(this);
  }

  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if the string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Extracts all numbers from the string.
  String get extractNumbers => replaceAll(RegExp(r'[^0-9]'), '');

  /// Masks part of the string (useful for sensitive data like credit cards).
  String mask({int start = 0, int end = 0, String maskChar = '*'}) {
    if (length < start + end) return this;
    final visibleStart = substring(0, start);
    final visibleEnd = substring(length - end);
    final masked = maskChar * (length - start - end);
    return '$visibleStart$masked$visibleEnd';
  }
}
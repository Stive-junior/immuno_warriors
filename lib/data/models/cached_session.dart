// Model for storing cached session data locally in Immuno Warriors.
import 'package:hive/hive.dart';

part 'cached_session.g.dart';

@HiveType(typeId: 16)
class CachedSession extends HiveObject {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String token;
  @HiveField(2)
  final DateTime expiryTime;

  CachedSession({
    required this.userId,
    required this.token,
    required this.expiryTime,
  });

  factory CachedSession.fromJson(Map<String, dynamic> json) {
    return CachedSession(
      userId: json['userId'] as String,
      token: json['token'] as String,
      expiryTime: DateTime.parse(json['expiryTime'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'token': token,
    'expiryTime': expiryTime.toIso8601String(),
  };

  /// Checks if the session is valid with a 1-hour grace period.
  bool get isValid =>
      expiryTime.isAfter(DateTime.now().subtract(const Duration(hours: 1)));
}

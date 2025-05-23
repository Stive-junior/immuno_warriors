import 'package:hive/hive.dart';

part 'cached_session.g.dart';

@HiveType(typeId: 7)
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

  bool get isValid => expiryTime.isAfter(DateTime.now());
}
/// Model for storing multiplayer session data locally in Immuno Warriors.
import 'package:hive/hive.dart';

part 'multiplayer_session_model.g.dart';

@HiveType(typeId: 8)
class MultiplayerSessionModel extends HiveObject {
  @HiveField(0)
  final String sessionId;
  @HiveField(1)
  final List<String> playerIds;
  @HiveField(2)
  final String status;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final Map<String, dynamic>? gameState;

  MultiplayerSessionModel({
    required this.sessionId,
    required this.playerIds,
    required this.status,
    required this.createdAt,
    this.gameState,
  });

  factory MultiplayerSessionModel.fromJson(Map<String, dynamic> json) {
    return MultiplayerSessionModel(
      sessionId: json['sessionId'] as String,
      playerIds: (json['playerIds'] as List<dynamic>?)?.cast<String>() ?? [],
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      gameState: json['gameState'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'playerIds': playerIds,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'gameState': gameState,
    };
  }
}
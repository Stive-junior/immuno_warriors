import 'package:hive/hive.dart';

part 'leaderboard_model.g.dart';

@HiveType(typeId: 18)
class LeaderboardModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final int rank;

  @HiveField(4)
  final String? updatedAt;

  @HiveField(5)
  final String? category;

  @HiveField(6)
  final bool? deleted;

  LeaderboardModel({
    required this.userId,
    required this.username,
    required this.score,
    required this.rank,
    this.updatedAt,
    this.category,
    this.deleted,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userId: json['userId'] as String? ?? 'unknown_user',
      username: json['username'] as String? ?? 'Anonyme',
      score: (json['score'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] as String?,
      category: json['category'] as String?,
      deleted: json['deleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'score': score,
      'rank': rank,
      'updatedAt': updatedAt,
      'category': category,
      'deleted': deleted,
    };
  }
}

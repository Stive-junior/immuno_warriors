/// Represents a leaderboard entry in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'leaderboard_entity.freezed.dart';
part 'leaderboard_entity.g.dart';

@freezed
class LeaderboardEntity with _$LeaderboardEntity, EquatableMixin {
  const LeaderboardEntity._();

  const factory LeaderboardEntity({
    required String userId,
    required String username,
    required int score,
    required int rank,
    DateTime? lastUpdated,
  }) = _LeaderboardEntity;

  factory LeaderboardEntity.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntityFromJson(json);

  /// Validates if the leaderboard entry is valid.
  bool get isValid => score >= 0 && rank > 0;

  /// Display name for UI.
  String get displayName => '$username (#$rank)';

  @override
  List<Object?> get props => [userId, username, score, rank, lastUpdated];
}

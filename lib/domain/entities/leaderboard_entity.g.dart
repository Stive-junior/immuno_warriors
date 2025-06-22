// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntityImpl _$$LeaderboardEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardEntityImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      score: (json['score'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$LeaderboardEntityImplToJson(
        _$LeaderboardEntityImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'score': instance.score,
      'rank': instance.rank,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

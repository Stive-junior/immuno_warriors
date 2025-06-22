/// Model for storing progression data locally in Immuno Warriors.
import 'package:hive/hive.dart';

part 'progression_model.g.dart';

@HiveType(typeId: 11)
class ProgressionModel extends HiveObject {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final int level;
  @HiveField(2)
  final int xp;
  @HiveField(3)
  final String? rank;
  @HiveField(4)
  final List<MissionModel> missions;

  ProgressionModel({
    required this.userId,
    required this.level,
    required this.xp,
    this.rank,
    required this.missions,
  });

  factory ProgressionModel.fromJson(Map<String, dynamic> json) {
    return ProgressionModel(
      userId: json['userId'] as String,
      level: json['level'] as int,
      xp: json['xp'] as int,
      rank: json['rank'] as String?,
      missions:
      (json['missions'] as List<dynamic>?)
          ?.map((m) => MissionModel.fromJson(m as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'level': level,
    'xp': xp,
    'rank': rank,
    'missions': missions.map((m) => m.toJson()).toList(),
  };
}

@HiveType(typeId: 21)
class MissionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final bool completed;

  MissionModel({
    required this.id,
    required this.completed,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'completed': completed,
  };
}
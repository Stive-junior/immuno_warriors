import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:immuno_warriors/data/models/progression_model.dart';

part 'progression_entity.freezed.dart';
part 'progression_entity.g.dart';

@freezed
class ProgressionEntity with _$ProgressionEntity, EquatableMixin {
  const ProgressionEntity._();

  const factory ProgressionEntity({
    required String userId,
    required int level,
    required int xp,
    String? rank,
    required List<MissionEntity> missions,
  }) = _ProgressionEntity;

  factory ProgressionEntity.fromJson(Map<String, dynamic> json) =>
      _$ProgressionEntityFromJson(json);

  factory ProgressionEntity.fromModel(ProgressionModel model) {
    return ProgressionEntity(
      userId: model.userId,
      level: model.level,
      xp: model.xp,
      rank: model.rank,
      missions: model.missions.map((m) => MissionEntity.fromModel(m)).toList(),
    );
  }

  ProgressionModel toModel() {
    return ProgressionModel(
      userId: userId,
      level: level,
      xp: xp,
      rank: rank,
      missions: missions.map((m) => m.toModel()).toList(),
    );
  }

  @override
  List<Object?> get props => [userId, level, xp, rank, missions];
}

@freezed
class MissionEntity with _$MissionEntity, EquatableMixin {
  const MissionEntity._();

  const factory MissionEntity({required String id, required bool completed}) =
      _MissionEntity;

  factory MissionEntity.fromJson(Map<String, dynamic> json) =>
      _$MissionEntityFromJson(json);

  factory MissionEntity.fromModel(MissionModel model) {
    return MissionEntity(id: model.id, completed: model.completed);
  }

  MissionModel toModel() {
    return MissionModel(id: id, completed: completed);
  }

  @override
  List<Object?> get props => [id, completed];
}

/// Represents a viral base in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/pathogen_types.dart';
import 'pathogen_entity.dart';

part 'base_virale_entity.freezed.dart';
part 'base_virale_entity.g.dart';

@freezed
class BaseViraleEntity with _$BaseViraleEntity, EquatableMixin {
  const BaseViraleEntity._();

  const factory BaseViraleEntity({
    required String id,
    required String playerId,
    required String name,
    required int level,
    required List<PathogenEntity> pathogens,
    required Map<DefenseType, int> defenses,
  }) = _BaseViraleEntity;

  factory BaseViraleEntity.fromJson(Map<String, dynamic> json) =>
      _$BaseViraleEntityFromJson(json);

  /// Calculates total defense value.
  int get totalDefense => defenses.values.fold(0, (sum, value) => sum + value);

  /// Validates if the base is ready for combat.
  bool get isCombatReady => pathogens.isNotEmpty && totalDefense > 0;

  @override
  List<Object?> get props => [id, playerId, name, level, pathogens, defenses];
}

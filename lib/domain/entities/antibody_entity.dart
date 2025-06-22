/// Represents an antibody in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/pathogen_types.dart';

part 'antibody_entity.freezed.dart';
part 'antibody_entity.g.dart';

@freezed
class AntibodyEntity with _$AntibodyEntity, EquatableMixin {
  const AntibodyEntity._();

  const factory AntibodyEntity({
    required String id,
    required AntibodyType type,
    required AttackType attackType,
    required int damage,
    required int range,
    required int cost,
    required double efficiency,
    required String name,
    required int health,
    required int maxHealth,
    String? specialAbility,
  }) = _AntibodyEntity;

  factory AntibodyEntity.fromJson(Map<String, dynamic> json) =>
      _$AntibodyEntityFromJson(json);

  /// Validates if the antibody is deployable.
  bool get isDeployable => health > 0 && cost >= 0;

  /// Calculates effective damage considering efficiency.
  int get effectiveDamage => (damage * efficiency).round();

  @override
  List<Object?> get props => [
    id,
    type,
    attackType,
    damage,
    range,
    cost,
    efficiency,
    name,
    health,
    maxHealth,
    specialAbility,
  ];
}
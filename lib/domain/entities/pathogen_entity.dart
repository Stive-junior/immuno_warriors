import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/pathogen_types.dart';

part 'pathogen_entity.freezed.dart';
part 'pathogen_entity.g.dart';

@freezed
class PathogenEntity with _$PathogenEntity, EquatableMixin {
  const PathogenEntity._();

  const factory PathogenEntity({
    required String id,
    required PathogenType type,
    required String name,
    required int health,
    required int attack,
    required AttackType attackType,
    required ResistanceType resistanceType,
    required PathogenRarity rarity,
    required double mutationRate,
    List<String>? abilities,
  }) = _PathogenEntity;

  factory PathogenEntity.fromJson(Map<String, dynamic> json) =>
      _$PathogenEntityFromJson(json);

  /// Determines if the pathogen can mutate based on its mutation rate.
  bool canMutate() =>
      mutationRate > (DateTime.now().millisecondsSinceEpoch % 100) / 100;

  /// Calculates effective attack considering abilities.
  int get effectiveAttack =>
      abilities?.contains('boost') == true ? attack * 2 : attack;

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    health,
    attack,
    attackType,
    resistanceType,
    rarity,
    mutationRate,
    abilities,
  ];
}

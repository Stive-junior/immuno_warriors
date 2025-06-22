/// Represents a research node in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/app_strings.dart';

part 'research_entity.freezed.dart';
part 'research_entity.g.dart';

@freezed
class ResearchEntity with _$ResearchEntity, EquatableMixin {
  const ResearchEntity._();

  const factory ResearchEntity({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'cost') required int researchCost,
    required List<String> prerequisites,
    required Map<String, dynamic> effects,
    required int level,
    @Default(false) bool isUnlocked,
  }) = _ResearchEntity;

  factory ResearchEntity.fromJson(Map<String, dynamic> json) =>
      _$ResearchEntityFromJson(json);

  /// Validates if the research can be unlocked based on prerequisites and cost.
  bool canUnlock(List<ResearchEntity> allResearches, int availableResources) {
    if (researchCost > availableResources) {
      return false;
    }
    if (prerequisites.isEmpty) {
      return true;
    }
    final prereqIds = prerequisites.toSet();
    return allResearches.every(
          (research) =>
      prereqIds.contains(research.id) ? research.isUnlocked : true,
    );
  }

  /// Display name for UI, using AppStrings.
  String get displayName => '$name ${AppStrings.level} $level';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    researchCost,
    prerequisites,
    effects,
    level,
    isUnlocked,
  ];
}

/// Represents a user in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity, EquatableMixin {
  const UserEntity._();

  const factory UserEntity({
    required String id,
    required String email,
    String? username,
    @JsonKey(name: 'avatarUrl') String? avatar,
    DateTime? createdAt,
    DateTime? lastLogin,
    Map<String, dynamic>? resources,
    Map<String, dynamic>? progression,
    Map<String, bool>? achievements,
    List<dynamic>? inventory,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  /// Checks if the user has enough resources for a cost.
  bool hasResources(String resourceType, int requiredAmount) {
    final resourceValue = (resources?[resourceType] as num?)?.toInt() ?? 0;
    return resourceValue >= requiredAmount;
  }

  /// Display name for UI, using AppStrings.
  String get displayName => username ?? email.split('@').first;

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    avatar,
    createdAt,
    lastLogin,
    resources,
    progression,
    achievements,
    inventory,
  ];
}

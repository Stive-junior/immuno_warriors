import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'progression_entity.dart';

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
    ProgressionEntity? progression,
    Map<String, bool>? achievements,
    List<InventoryItemModel>? inventory,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      username: model.username,
      avatar: model.avatar,
      createdAt: model.createdAt,
      lastLogin: model.lastLogin,
      resources: model.resources,
      progression:
          model.progression != null
              ? ProgressionEntity.fromModel(model.progression!)
              : null,
      achievements: model.achievements,
      inventory: model.inventory,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      createdAt: createdAt,
      lastLogin: lastLogin,
      resources: resources,
      progression: progression?.toModel(),
      achievements: achievements,
      inventory: inventory,
    );
  }

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

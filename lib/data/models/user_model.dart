import 'package:hive/hive.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';
import 'package:immuno_warriors/data/models/progression_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 13)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? username;
  @HiveField(3)
  final String? avatar;
  @HiveField(4)
  final DateTime? createdAt;
  @HiveField(5)
  final DateTime? lastLogin;
  @HiveField(6)
  final Map<String, dynamic>? resources;
  @HiveField(7)
  final ProgressionModel? progression;
  @HiveField(8)
  final Map<String, bool>? achievements;
  @HiveField(9)
  final List<InventoryItemModel>? inventory;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.avatar,
    this.createdAt,
    this.lastLogin,
    this.resources,
    this.progression,
    this.achievements,
    this.inventory,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatar: json['avatarUrl'] as String?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      lastLogin:
          json['lastLogin'] != null
              ? DateTime.parse(json['lastLogin'] as String)
              : null,
      resources: json['resources'] as Map<String, dynamic>?,
      progression:
          json['progression'] != null
              ? ProgressionModel.fromJson(json['progression'])
              : null,
      achievements: (json['achievements'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as bool),
      ),
      inventory:
          (json['inventory'] as List<dynamic>?)
              ?.map(
                (e) => InventoryItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'avatarUrl': avatar,
    'createdAt': createdAt?.toIso8601String(),
    'lastLogin': lastLogin?.toIso8601String(),
    'resources': resources,
    'progression': progression?.toJson(),
    'achievements': achievements,
    'inventory': inventory?.map((e) => e.toJson()).toList(),
  };

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    DateTime? createdAt,
    DateTime? lastLogin,
    Map<String, dynamic>? resources,
    ProgressionModel? progression,
    Map<String, bool>? achievements,
    List<InventoryItemModel>? inventory,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      resources: resources ?? this.resources,
      progression: progression ?? this.progression,
      achievements: achievements ?? this.achievements,
      inventory: inventory ?? this.inventory,
    );
  }

  UserEntity toEntity() {
    return UserEntity.fromModel(this);
  }

  bool hasResources(String resourceType, int amount) =>
      ((resources?[resourceType] as num?)?.toInt() ?? 0) >= amount;
}

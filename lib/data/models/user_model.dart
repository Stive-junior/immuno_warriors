/// Model for storing user data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 12)
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
  final Map<String, dynamic>? progression;
  @HiveField(8)
  final Map<String, bool>? achievements;
  @HiveField(9)
  final List<dynamic>? inventory;

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
      progression: json['progression'] as Map<String, dynamic>?,
      achievements: (json['achievements'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as bool),
      ),
      inventory: json['inventory'] as List<dynamic>?,
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
    'progression': progression,
    'achievements': achievements,
    'inventory': inventory,
  };

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      avatar: entity.avatar,
      createdAt: entity.createdAt,
      lastLogin: entity.lastLogin,
      resources: entity.resources,
      progression: entity.progression,
      achievements: entity.achievements,
      inventory: entity.inventory,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      createdAt: createdAt,
      lastLogin: lastLogin,
      resources: resources,
      progression: progression,
      achievements: achievements,
      inventory: inventory,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    Map<String, dynamic>? resources,
    Map<String, dynamic>? progression,
    Map<String, bool>? achievements,
    List<dynamic>? inventory,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      resources: resources ?? this.resources,
      progression: progression ?? this.progression,
      achievements: achievements ?? this.achievements,
      inventory: inventory ?? this.inventory,
    );
  }

  Object hasResources(String resourceType, int amount) =>
      (resources?[resourceType] as num?)?.toInt() ?? 0 >= amount;
}

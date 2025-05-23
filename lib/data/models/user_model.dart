import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? username;
  @HiveField(3)
  final String? avatarUrl;
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
    this.avatarUrl,
    this.createdAt,
    this.lastLogin,
    this.resources,
    this.progression,
    this.achievements,
    this.inventory,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
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
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      lastLogin: lastLogin,
      resources: resources,
      progression: progression,
      achievements: achievements,
      inventory: inventory,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt']?.toDate(),
      lastLogin: json['lastLogin']?.toDate(),
      resources: json['resources'] as Map<String, dynamic>?,
      progression: json['progression'] as Map<String, dynamic>?,
      achievements: (json['achievements'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as bool),
      ),
      inventory: json['inventory'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'resources': resources,
      'progression': progression,
      'achievements': achievements,
      'inventory': inventory,
    };
  }
}
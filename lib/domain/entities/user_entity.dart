class UserEntity {
  final String id;
  final String email;
  final String? username;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final Map<String, dynamic>? resources;
  final Map<String, dynamic>? progression;
  final Map<String, bool>? achievements;
  final List<dynamic>? inventory;

  const UserEntity({
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

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
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
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'resources': resources,
      'progression': progression,
      'achievements': achievements,
      'inventory': inventory,
    };
  }


  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    DateTime? createdAt,
    required DateTime lastLogin,
    Map<String, dynamic>? resources,
    Map<String, dynamic>? progression,
    Map<String, bool>? achievements,
    List<dynamic>? inventory,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin,
      resources: resources ?? this.resources,
      progression: progression ?? this.progression,
      achievements: achievements ?? this.achievements,
      inventory: inventory ?? this.inventory,
    );
  }

}
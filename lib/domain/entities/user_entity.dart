
class UserEntity {
  final String id;
  final String email;
  final int resources;
  final int researchPoints;
  final int bioMaterials;

  UserEntity({
    required this.id,
    required this.email,
    required this.resources,
    required this.researchPoints,
    required this.bioMaterials,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    int? resources,
    int? researchPoints,
    int? bioMaterials,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      resources: resources ?? this.resources,
      researchPoints: researchPoints ?? this.researchPoints,
      bioMaterials: bioMaterials ?? this.bioMaterials,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'resources': resources,
      'researchPoints': researchPoints,
      'bioMaterials': bioMaterials,
    };
  }


}
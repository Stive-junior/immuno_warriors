import 'package:hive/hive.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final int resources;
  @HiveField(3)
  final int researchPoints;
  @HiveField(4)
  final int bioMaterials;

  UserModel({
    required this.id,
    required this.email,
    required this.resources,
    required this.researchPoints,
    required this.bioMaterials,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      resources: json['resources'] as int,
      researchPoints: json['researchPoints'] as int,
      bioMaterials: json['bioMaterials'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'resources': resources,
    'researchPoints': researchPoints,
    'bioMaterials': bioMaterials,
  };

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      resources: entity.resources,
      researchPoints: entity.researchPoints,
      bioMaterials: entity.bioMaterials,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      resources: resources,
      researchPoints: researchPoints,
      bioMaterials: bioMaterials,
    );
  }
}
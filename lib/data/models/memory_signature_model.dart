// Model for storing memory signature data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import '../../../domain/entities/memory_signature.dart';

part 'memory_signature_model.g.dart';

@HiveType(typeId: 7)
class MemorySignatureModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String pathogenType;

  @HiveField(3)
  final int attackBonus;

  @HiveField(4)
  final int defenseBonus;

  @HiveField(5)
  final String expiryDate;

  MemorySignatureModel({
    required this.id,
    required this.userId,
    required this.pathogenType,
    required this.attackBonus,
    required this.defenseBonus,
    required this.expiryDate,
  });

  factory MemorySignatureModel.fromJson(Map<String, dynamic> json) {
    return MemorySignatureModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      pathogenType: json['pathogenType'] as String,
      attackBonus: json['attackBonus'] as int,
      defenseBonus: json['defenseBonus'] as int,
      expiryDate: json['expiryDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'pathogenType': pathogenType,
      'attackBonus': attackBonus,
      'defenseBonus': defenseBonus,
      'expiryDate': expiryDate,
    };
  }

  MemorySignature toEntity() {
    return MemorySignature(
      pathogenType: pathogenType,
      attackBonus: attackBonus,
      defenseBonus: defenseBonus,
      expiryDate: expiryDate,
    );
  }
}

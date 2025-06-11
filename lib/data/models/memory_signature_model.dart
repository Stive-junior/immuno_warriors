// Model for storing memory signature data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import '../../../domain/entities/memory_signature.dart';

part 'memory_signature_model.g.dart';

@HiveType(typeId: 19)
class MemorySignatureModel extends HiveObject {
  @HiveField(0)
  final String pathogenType;
  @HiveField(1)
  final double attackBonus;
  @HiveField(2)
  final double defenseBonus;
  @HiveField(3)
  final DateTime expiryDate;

  MemorySignatureModel({
    required this.pathogenType,
    required this.attackBonus,
    required this.defenseBonus,
    required this.expiryDate,
  });

  factory MemorySignatureModel.fromJson(Map<String, dynamic> json) =>
      MemorySignatureModel.fromEntity(MemorySignature.fromJson(json));

  Map<String, dynamic> toJson() => toEntity().toJson();

  factory MemorySignatureModel.fromEntity(MemorySignature entity) {
    return MemorySignatureModel(
      pathogenType: entity.pathogenType,
      attackBonus: entity.attackBonus,
      defenseBonus: entity.defenseBonus,
      expiryDate: entity.expiryDate,
    );
  }

  MemorySignature toEntity() {
    return MemorySignature(
      pathogenType: pathogenType,
      attackBonus: attackBonus,
      defenseBonus: defenseBonus,
      expiryDate: expiryDate,
    );
  }

  /// Validates if the signature is valid with a 1-hour grace period.
  bool get isValid =>
      expiryDate.isAfter(DateTime.now().subtract(Duration(hours: 1))) &&
      attackBonus >= 0 &&
      defenseBonus >= 0;
}

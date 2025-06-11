// Represents a memory signature for pathogen encounters in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'memory_signature.freezed.dart';
part 'memory_signature.g.dart';

@freezed
class MemorySignature with _$MemorySignature, EquatableMixin {
  const MemorySignature._();

  const factory MemorySignature({
    required String pathogenType,
    required double attackBonus,
    required double defenseBonus,
    required DateTime expiryDate,
  }) = _MemorySignature;

  factory MemorySignature.fromJson(Map<String, dynamic> json) =>
      _$MemorySignatureFromJson(json);

  /// Checks if the signature is valid, including a 1-hour grace period.
  bool isValid() =>
      expiryDate.isAfter(DateTime.now().subtract(const Duration(hours: 1)));

  @override
  List<Object?> get props => [
    pathogenType,
    attackBonus,
    defenseBonus,
    expiryDate,
  ];
}

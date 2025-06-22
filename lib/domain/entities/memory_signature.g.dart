// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemorySignatureImpl _$$MemorySignatureImplFromJson(
        Map<String, dynamic> json) =>
    _$MemorySignatureImpl(
      pathogenType: json['pathogenType'] as String,
      attackBonus: (json['attackBonus'] as num).toInt(),
      defenseBonus: (json['defenseBonus'] as num).toInt(),
      expiryDate: json['expiryDate'] as String,
    );

Map<String, dynamic> _$$MemorySignatureImplToJson(
        _$MemorySignatureImpl instance) =>
    <String, dynamic>{
      'pathogenType': instance.pathogenType,
      'attackBonus': instance.attackBonus,
      'defenseBonus': instance.defenseBonus,
      'expiryDate': instance.expiryDate,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemEntityImpl _$$InventoryItemEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryItemEntityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InventoryItemEntityImplToJson(
        _$InventoryItemEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'name': instance.name,
      'quantity': instance.quantity,
      'metadata': instance.metadata,
    };

const _$ItemTypeEnumMap = {
  ItemType.resource: 'resource',
  ItemType.equipment: 'equipment',
  ItemType.boost: 'boost',
};

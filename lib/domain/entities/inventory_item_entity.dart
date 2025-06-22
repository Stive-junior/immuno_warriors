/// Represents an inventory item in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'inventory_item_entity.freezed.dart';
part 'inventory_item_entity.g.dart';

enum ItemType { resource, equipment, boost }

@freezed
class InventoryItemEntity with _$InventoryItemEntity, EquatableMixin {
  const InventoryItemEntity._();

  const factory InventoryItemEntity({
    required String id,
    required String userId,
    required ItemType type,
    required String name,
    required int quantity,
    Map<String, dynamic>? metadata,
  }) = _InventoryItemEntity;

  factory InventoryItemEntity.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemEntityFromJson(json);

  /// Validates if the item is usable.
  bool get isUsable => quantity > 0;

  /// Display name for UI.
  String get displayName => '$name (${type.toString().split('.').last})';

  @override
  List<Object?> get props => [id, userId, type, name, quantity, metadata];
}
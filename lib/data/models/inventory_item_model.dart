import 'package:hive/hive.dart';

part 'inventory_item_model.g.dart';

@HiveType(typeId: 17)
class InventoryItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final Map<String, dynamic> properties;

  InventoryItemModel({
    required this.id,
    required this.type,
    required this.name,
    required this.quantity,
    required this.properties,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'quantity': quantity,
      'properties': properties,
    };
  }
}

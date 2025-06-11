// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_signature_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemorySignatureModelAdapter extends TypeAdapter<MemorySignatureModel> {
  @override
  final int typeId = 19;

  @override
  MemorySignatureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemorySignatureModel(
      pathogenType: fields[0] as String,
      attackBonus: fields[1] as double,
      defenseBonus: fields[2] as double,
      expiryDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MemorySignatureModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pathogenType)
      ..writeByte(1)
      ..write(obj.attackBonus)
      ..writeByte(2)
      ..write(obj.defenseBonus)
      ..writeByte(3)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemorySignatureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

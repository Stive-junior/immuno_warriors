// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_signature_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemorySignatureModelAdapter extends TypeAdapter<MemorySignatureModel> {
  @override
  final int typeId = 7;

  @override
  MemorySignatureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemorySignatureModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      pathogenType: fields[2] as String,
      attackBonus: fields[3] as int,
      defenseBonus: fields[4] as int,
      expiryDate: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemorySignatureModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.pathogenType)
      ..writeByte(3)
      ..write(obj.attackBonus)
      ..writeByte(4)
      ..write(obj.defenseBonus)
      ..writeByte(5)
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

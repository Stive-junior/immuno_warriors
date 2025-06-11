// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_viral_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseViraleModelAdapter extends TypeAdapter<BaseViraleModel> {
  @override
  final int typeId = 13;

  @override
  BaseViraleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseViraleModel(
      id: fields[0] as String,
      playerId: fields[1] as String,
      name: fields[2] as String,
      level: fields[3] as int,
      pathogens: (fields[4] as List).cast<PathogenModel>(),
      defenses: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, BaseViraleModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.pathogens)
      ..writeByte(5)
      ..write(obj.defenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseViraleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

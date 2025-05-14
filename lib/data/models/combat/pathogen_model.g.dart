// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathogen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PathogenModelAdapter extends TypeAdapter<PathogenModel> {
  @override
  final int typeId = 2;

  @override
  PathogenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PathogenModel(
      id: fields[0] as String,
      type: fields[1] as PathogenType,
      name: fields[2] as String,
      health: fields[3] as int,
      attack: fields[4] as int,
      attackType: fields[5] as AttackType,
      resistanceType: fields[6] as ResistanceType,
      rarity: fields[7] as PathogenRarity,
      mutationRate: fields[8] as double,
      abilities: (fields[9] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PathogenModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.health)
      ..writeByte(4)
      ..write(obj.attack)
      ..writeByte(5)
      ..write(obj.attackType)
      ..writeByte(6)
      ..write(obj.resistanceType)
      ..writeByte(7)
      ..write(obj.rarity)
      ..writeByte(8)
      ..write(obj.mutationRate)
      ..writeByte(9)
      ..write(obj.abilities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathogenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

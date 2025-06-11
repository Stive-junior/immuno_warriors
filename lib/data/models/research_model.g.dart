// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResearchModelAdapter extends TypeAdapter<ResearchModel> {
  @override
  final int typeId = 10;

  @override
  ResearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResearchModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      researchCost: fields[3] as int,
      prerequisites: (fields[4] as List).cast<String>(),
      effects: (fields[5] as Map).cast<String, dynamic>(),
      level: fields[6] as int,
      isUnlocked: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ResearchModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.researchCost)
      ..writeByte(4)
      ..write(obj.prerequisites)
      ..writeByte(5)
      ..write(obj.effects)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

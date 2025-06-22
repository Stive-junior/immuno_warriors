// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressionModelAdapter extends TypeAdapter<ProgressionModel> {
  @override
  final int typeId = 11;

  @override
  ProgressionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressionModel(
      userId: fields[0] as String,
      level: fields[1] as int,
      xp: fields[2] as int,
      rank: fields[3] as String?,
      missions: (fields[4] as List).cast<MissionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgressionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.xp)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.missions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MissionModelAdapter extends TypeAdapter<MissionModel> {
  @override
  final int typeId = 21;

  @override
  MissionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissionModel(
      id: fields[0] as String,
      completed: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MissionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

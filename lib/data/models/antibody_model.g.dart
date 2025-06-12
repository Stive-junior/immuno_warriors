// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antibody_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AntibodyModelAdapter extends TypeAdapter<AntibodyModel> {
  @override
  final int typeId = 14;

  @override
  AntibodyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AntibodyModel(
      id: fields[0] as String,
      type: fields[1] as AntibodyType,
      attackType: fields[2] as AttackType,
      damage: fields[3] as int,
      range: fields[4] as int,
      cost: fields[5] as int,
      efficiency: fields[6] as double,
      name: fields[7] as String,
      health: fields[8] as int,
      maxHealth: fields[9] as int,
      specialAbility: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AntibodyModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.attackType)
      ..writeByte(3)
      ..write(obj.damage)
      ..writeByte(4)
      ..write(obj.range)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.efficiency)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.health)
      ..writeByte(9)
      ..write(obj.maxHealth)
      ..writeByte(10)
      ..write(obj.specialAbility);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntibodyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

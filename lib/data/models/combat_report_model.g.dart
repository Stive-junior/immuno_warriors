// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CombatReportModelAdapter extends TypeAdapter<CombatReportModel> {
  @override
  final int typeId = 4;

  @override
  CombatReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CombatReportModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      result: fields[2] as CombatResult,
      log: (fields[3] as List).cast<String>(),
      damageDealt: fields[4] as int,
      damageTaken: fields[5] as int,
      unitsDeployed: (fields[6] as List).cast<String>(),
      unitsLost: (fields[7] as List).cast<String>(),
      baseId: fields[8] as String,
      antibodiesUsed: (fields[9] as List?)?.cast<AntibodyEntity>(),
      pathogenFought: fields[10] as PathogenEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, CombatReportModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.log)
      ..writeByte(4)
      ..write(obj.damageDealt)
      ..writeByte(5)
      ..write(obj.damageTaken)
      ..writeByte(6)
      ..write(obj.unitsDeployed)
      ..writeByte(7)
      ..write(obj.unitsLost)
      ..writeByte(8)
      ..write(obj.baseId)
      ..writeByte(9)
      ..write(obj.antibodiesUsed)
      ..writeByte(10)
      ..write(obj.pathogenFought);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombatReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

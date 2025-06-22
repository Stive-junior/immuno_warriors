// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedSessionAdapter extends TypeAdapter<CachedSession> {
  @override
  final int typeId = 3;

  @override
  CachedSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedSession(
      userId: fields[0] as String,
      token: fields[1] as String,
      expiryTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.expiryTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

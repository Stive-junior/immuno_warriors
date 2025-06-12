// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiplayer_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MultiplayerSessionModelAdapter
    extends TypeAdapter<MultiplayerSessionModel> {
  @override
  final int typeId = 19;

  @override
  MultiplayerSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultiplayerSessionModel(
      sessionId: fields[0] as String,
      playerIds: (fields[1] as List).cast<String>(),
      status: fields[2] as String,
      createdAt: fields[3] as DateTime,
      gameState: (fields[4] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MultiplayerSessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.playerIds)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.gameState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiplayerSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

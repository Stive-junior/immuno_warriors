// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaderboardModelAdapter extends TypeAdapter<LeaderboardModel> {
  @override
  final int typeId = 18;

  @override
  LeaderboardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaderboardModel(
      userId: fields[0] as String,
      username: fields[1] as String,
      score: fields[2] as int,
      rank: fields[3] as int,
      updatedAt: fields[4] as String?,
      category: fields[5] as String?,
      deleted: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LeaderboardModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

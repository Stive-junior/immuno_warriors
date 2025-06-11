// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 12;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      username: fields[2] as String?,
      avatar: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      lastLogin: fields[5] as DateTime?,
      resources: (fields[6] as Map?)?.cast<String, dynamic>(),
      progression: (fields[7] as Map?)?.cast<String, dynamic>(),
      achievements: (fields[8] as Map?)?.cast<String, bool>(),
      inventory: (fields[9] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastLogin)
      ..writeByte(6)
      ..write(obj.resources)
      ..writeByte(7)
      ..write(obj.progression)
      ..writeByte(8)
      ..write(obj.achievements)
      ..writeByte(9)
      ..write(obj.inventory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeminiResponseAdapter extends TypeAdapter<GeminiResponse> {
  @override
  final int typeId = 15;

  @override
  GeminiResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeminiResponse(
      id: fields[0] as String,
      type: fields[1] as String,
      content: fields[2] as String,
      timestamp: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeminiResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeminiResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

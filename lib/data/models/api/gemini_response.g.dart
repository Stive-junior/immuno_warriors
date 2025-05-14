// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeminiResponseAdapter extends TypeAdapter<GeminiResponse> {
  @override
  final int typeId = 1;

  @override
  GeminiResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeminiResponse(
      text: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeminiResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
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

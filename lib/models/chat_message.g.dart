// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 0;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      request: fields[0] as String,
      response: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.request)
      ..writeByte(1)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatRecordAdapter extends TypeAdapter<ChatRecord> {
  @override
  final int typeId = 1;

  @override
  ChatRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRecord(
      caller: fields[1] as String,
      topic: fields[2] as String,
    )..messages = (fields[0] as List).cast<ChatMessage>();
  }

  @override
  void write(BinaryWriter writer, ChatRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.messages)
      ..writeByte(1)
      ..write(obj.caller)
      ..writeByte(2)
      ..write(obj.topic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

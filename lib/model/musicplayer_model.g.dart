// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musicplayer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicPlayeerModelAdapter extends TypeAdapter<MusicPlayeerModel> {
  @override
  final int typeId = 1;

  @override
  MusicPlayeerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicPlayeerModel(
      songsId: (fields[1] as List).cast<int>(),
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MusicPlayeerModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.songsId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicPlayeerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

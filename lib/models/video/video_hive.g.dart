// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoHiveModelAdapter extends TypeAdapter<VideoHiveModel> {
  @override
  final int typeId = 0;

  @override
  VideoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      thumbnailUrl: fields[3] as String,
      channelTitle: fields[4] as String,
      dateAdded: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.channelTitle)
      ..writeByte(5)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

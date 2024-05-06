// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedFileAdapter extends TypeAdapter<DownloadedFile> {
  @override
  final int typeId = 0;

  @override
  DownloadedFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedFile(
      id: fields[0] as String?,
      taskId: fields[1] as String?,
      videoPath: fields[3] as String?,
      videoTitle: fields[2] as String?,
      videoThumbnail: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.videoTitle)
      ..writeByte(3)
      ..write(obj.videoPath)
      ..writeByte(4)
      ..write(obj.videoThumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

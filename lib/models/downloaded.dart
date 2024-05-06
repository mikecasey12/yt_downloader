import 'package:hive_flutter/hive_flutter.dart';

part 'downloaded.g.dart';

@HiveType(typeId: 0)
class DownloadedFile {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? taskId;
  @HiveField(2)
  final String? videoTitle;
  @HiveField(3)
  final String? videoPath;
  @HiveField(4)
  final String? videoThumbnail;

  DownloadedFile({
    required this.id,
    required this.taskId,
    required this.videoPath,
    required this.videoTitle,
    required this.videoThumbnail,
  });
}

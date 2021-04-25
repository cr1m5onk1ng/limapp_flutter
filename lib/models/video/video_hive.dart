import 'package:hive/hive.dart';
import 'package:limapp/models/models.dart';

part 'video_hive.g.dart';

@HiveType(typeId: 0)
class VideoHiveModel extends VideoModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String thumbnailUrl;
  @HiveField(4)
  final String channelTitle;
  @HiveField(5)
  final String dateAdded;

  VideoHiveModel({
    this.id,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.channelTitle,
    this.dateAdded,
  });
}

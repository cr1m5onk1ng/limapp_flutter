import 'package:hive/hive.dart';
import 'package:limapp/application/reader/metadata_service.dart';
import 'package:limapp/models/reader/article_hive.dart';
import 'package:limapp/models/video/video_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/video/video_hive.dart';

class DatabaseService {
  final _yt = YoutubeExplode();
  final _md = MetadataService();

  Future<void> addVideo(String videoId) async {
    final videoBox = await Hive.openBox<VideoHiveModel>('videos');

    final video = await _yt.videos.get(videoId);
    final title = video.title;
    final author = video.author;
    final thumbnail = video.thumbnails.highResUrl;
    final description = video.description;
    final dateAdded = DateTime.now().toString();

    final videoModel = VideoHiveModel(
      id: videoId,
      title: title,
      description: description,
      thumbnailUrl: thumbnail,
      channelTitle: author,
      dateAdded: dateAdded,
    );
    videoBox.put(dateAdded, videoModel);
  }

  Future<void> deleteVideo(VideoModel video) async {}

  Future<void> addArticle(String url) async {
    final articleBox = await Hive.openBox<Article>('articles');
    final article = await _md.getArticleMetadataFromUrl(url);
    articleBox.put(article.dateAdded, article);
  }

  Future<void> deleteArticle(Article article) async {
    final articleBox = await Hive.openBox<Article>('articles');
    articleBox.delete(article.dateAdded);
  }
}

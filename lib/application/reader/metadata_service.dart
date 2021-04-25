import 'package:limapp/models/reader/article_hive.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

class MetadataService {
  Future<Article> getArticleMetadataFromUrl(String url) async {
    final data = await extract(url);
    final title = data.title ?? '';
    final description = data.description ?? '';
    final thumbnail = data.image ?? '';
    return Article(
      url: url,
      title: title,
      description: description,
      thumbnail: thumbnail,
      dateAdded: DateTime.now().toString(),
    );
  }
}

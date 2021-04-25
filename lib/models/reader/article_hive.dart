import 'package:hive/hive.dart';

part 'article_hive.g.dart';

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String thumbnail;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String dateAdded;

  Article(
      {this.url, this.title, this.thumbnail, this.description, this.dateAdded});
}

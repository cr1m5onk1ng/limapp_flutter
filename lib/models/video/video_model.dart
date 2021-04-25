class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;

  VideoModel({
    this.id,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory VideoModel.fromMap(Map<String, dynamic> jsonElement) {
    return VideoModel(
      id: jsonElement['id']['videoId'],
      title: jsonElement['snippet']['title'],
      description: jsonElement['snippet']['description'],
      thumbnailUrl: jsonElement['snippet']['thumbnails']['high']['url'],
      channelTitle: jsonElement['snippet']['channelTitle'],
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is VideoModel && o.id == this.id) return true;
    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => this.id.hashCode;
}

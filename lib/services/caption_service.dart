import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class _YoutubeExplodeData {
  ClosedCaptionManifest manifest;
  ClosedCaptionTrackInfo trackInfo;
  ClosedCaptionTrack track;

  _YoutubeExplodeData({this.manifest, this.trackInfo, this.track});
}

class CaptionService {
  final YoutubeExplode _yt;
  _YoutubeExplodeData data;

  CaptionService() : _yt = YoutubeExplode();

  Future<_YoutubeExplodeData> initData(String videoId) async {
    final manifest = await _yt.videos.closedCaptions.getManifest(videoId);
    final trackInfo = manifest.getByLanguage("ja").first;
    final track = await _yt.videos.closedCaptions.get(trackInfo);
    return _YoutubeExplodeData(
        manifest: manifest, trackInfo: trackInfo, track: track);
  }

  Future<ClosedCaption> getCaptionByTime(
    String videoId,
    Duration duration,
  ) async {
    await checkInitialized(videoId);
    final caption = this.data.track.getByTime(duration);
    return caption;
  }

  Future<String> getSubtitles(String videoId) async {
    await checkInitialized(videoId);
    var subtitles =
        await _yt.videos.closedCaptions.getSubTitles(this.data.trackInfo);
    return subtitles;
  }

  Future<List<Comment>> getComments(String videoId) async {
    var video = await _yt.videos.get(videoId);
    var comments =
        await _yt.videos.commentsClient.getComments(video).take(20).toList();
    return comments;
  }

  Future<void> checkInitialized(String videoId) async {
    if (this.data == null) this.data = await initData(videoId);
  }

  void dispose() {
    _yt.close();
  }
}

class NoTrackFoundException implements Exception {
  String message;
  NoTrackFoundException(this.message);
}

class NoCaptionAvailableException implements Exception {
  String message;

  NoCaptionAvailableException(this.message);
}

/*
final captionServiceProvider =
    Provider<CaptionService>((_) => CaptionService());

class CaptionService {
  final YoutubeExplode _yt;

  CaptionService() : _yt = YoutubeExplode();

  Future<ClosedCaptionManifest> getManifestFromId(String videoId) async {
    return await _yt.videos.closedCaptions.getManifest(videoId);
  }

  List<ClosedCaptionTrackInfo> getTrackInfoByLanguage(
      ClosedCaptionManifest manifest, String lang) {
    var trackInfo = manifest.getByLanguage(lang);
    if (trackInfo == null)
      throw NoTrackFoundException("No track found for the specified language");
    return trackInfo;
  }

  Future<ClosedCaptionTrack> getTrack(ClosedCaptionTrackInfo trackInfo) async {
    return await _yt.videos.closedCaptions.get(trackInfo);
  }

  List<ClosedCaption> getAllCaptions(ClosedCaptionTrack track) {
    return track.captions;
  }

  ClosedCaption getCaptionByTime(ClosedCaptionTrack track, Duration duration) {
    return track.getByTime(duration);
  }

  String getText(ClosedCaption caption) {
    return caption.text;
  }

  Future<ClosedCaption> getCaptionByDuration(
      {String videoId, String lang, Duration duration}) async {
    var manifest = await getManifestFromId(videoId);

    var trackInfo = getTrackInfoByLanguage(manifest, lang);

    if (trackInfo != null) {
      var track = await getTrack(trackInfo.first);

      var caption = getByTime(track, duration);
      return caption;
    } else {
      throw NoCaptionAvailableException(
          "No caption available for the selected language");
    }
  }

  void dispose() {
    _yt.close();
  }
}

class NoTrackFoundException implements Exception {
  String message;
  NoTrackFoundException(this.message);
}

class NoCaptionAvailableException implements Exception {
  String message;

  NoCaptionAvailableException(this.message);
}

*/

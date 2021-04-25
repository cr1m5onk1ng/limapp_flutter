import 'dart:convert';
import 'dart:io';
import 'package:limapp/models/settings/api_parameters.dart';
import 'package:http/http.dart' as http;
import 'package:limapp/models/video/channel_model.dart';
import 'package:limapp/models/video/video_model.dart';
import 'package:limapp/utilities/keys.dart';

class SearchService {
  final String baseUrl;
  final apiParameters;
  String _nextPageToken;
  String _lastSearchQuery;

  SearchService()
      : baseUrl = 'www.googleapis.com',
        apiParameters = ApiParameters();

  Future<List<VideoModel>> fetchVideosFromSearchQuery(String query) async {
    apiParameters.setQuery = query;
    _lastSearchQuery = query;
    Map<String, String> parameters = apiParameters.toParameters(_nextPageToken);

    Uri uri = Uri.https(
      baseUrl,
      '/youtube/v3/search',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'];
      List<dynamic> videosJson = data['items'];

      if (videosJson.isEmpty) throw NoSearchResultsException();

      // Fetch first n videos from uploads playlist
      List<VideoModel> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          VideoModel.fromMap(json),
        ),
      );
      return videos;
    } else {
      throw SearchError(json.decode(response.body)['error']['message']);
    }
  }

  Future<List<VideoModel>> fetchNextPageVideos() async {
    if (_lastSearchQuery == null) {
      throw SearchNotInitiatedException();
    }

    if (_nextPageToken == null) {
      throw NoNextPageTokenException();
    }

    final nextVideos = await fetchVideosFromSearchQuery(_lastSearchQuery);

    return nextVideos;
  }

  Future<Channel> fetchChannel(String channelId) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      channel.videos = await fetchVideosFromPlaylist(
        channel.uploadPlaylistId,
      );

      return channel;
    } else {
      throw SearchError(json.decode(response.body)['error']['message']);
    }
  }

  Future<List<VideoModel>> fetchVideosFromPlaylist(String playlistId) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'];
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<VideoModel> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          VideoModel.fromMap(json),
        ),
      );
      return videos;
    } else {
      throw SearchError(json.decode(response.body)['error']['message']);
    }
  }
}

class SearchError implements Exception {
  String message;

  SearchError(this.message);
}

class NoSearchResultsException implements Exception {
  final message = 'No results';
}

class SearchNotInitiatedException implements Exception {
  final message = 'Cannot get the next result page without searching first.';
}

class NoNextPageTokenException implements Exception {}

class NoSuchVideoException implements Exception {
  final message = 'No such video';
}

class NoMetadataException implements Exception {
  final message = 'No metadata for the current video';
}

class NetworkError extends Error {}

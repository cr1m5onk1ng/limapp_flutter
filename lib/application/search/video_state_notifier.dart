import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/video/video_providers.dart';
import 'package:limapp/application/search/video_state.dart';

import '../../models/video/channel_model.dart';
import '../../models/video/video_model.dart';
import '../../services/search_api_service.dart';

class VideoStateNotifier extends StateNotifier<VideoState> {
  final SearchService _service;
  VideoStateNotifier(this._service) : super(VideoInitial());

  Future<void> getVideosFromChannel(Channel channel) async {
    try {
      state = VideoLoading();
      List<VideoModel> videos =
          await _service.fetchVideosFromPlaylist(channel.uploadPlaylistId);
      state = VideoLoaded(videos);
    } on NetworkError {
      state = VideoError("Couldn't fetch the videos. Check the connection.");
    }
  }
}

final videoStateNotifierProvider = StateNotifierProvider<VideoStateNotifier>(
    (ref) => VideoStateNotifier(ref.watch(searchApiProvider)));

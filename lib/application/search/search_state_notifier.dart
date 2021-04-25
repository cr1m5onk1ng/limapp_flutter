import 'package:limapp/application/search/search_state.dart';
import 'package:limapp/models/video/video_model.dart';
import 'package:limapp/services/search_api_service.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchStateNotifier extends StateNotifier<SearchState> {
  final SearchService _service;
  final _yt = YoutubeExplode();

  SearchStateNotifier(this._service) : super(SearchState.initial());

  Future<void> fetchInitialResults(String query) async {
    state = SearchState.loading();
    try {
      List<VideoModel> searchResults =
          await _service.fetchVideosFromSearchQuery(query);
      state = SearchState.success(searchResults);
    } on SearchError catch (e) {
      state = SearchState.failure(e.message);
    } on NoSearchResultsException catch (e) {
      state = SearchState.failure(e.message);
    }
  }

  Future<void> fetchNextResults() async {
    try {
      List<VideoModel> nextResults = await _service.fetchNextPageVideos();
      state = SearchState.success(state.searchResults + nextResults);
    } on NoNextPageTokenException catch (_) {
      state = SearchState.endOfResults(state.searchResults);
    } on SearchNotInitiatedException catch (e) {
      state = SearchState.failure(e.message);
    } on SearchError catch (e) {
      state = SearchState.failure(e.message);
    }
  }

  void setSharedView(List<VideoModel> viewed) {
    state = SearchState.shared(viewed);
  }
}

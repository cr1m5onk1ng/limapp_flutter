import 'package:limapp/application/state.dart';
import 'package:limapp/models/video/video_model.dart';

class SearchState implements ApplicationState {
  bool isLoading;
  bool hasReachedEndOfResults;
  bool isContentShared;
  bool isSearch = false;
  List<VideoModel> searchResults;
  String error;

  SearchState({
    this.isLoading,
    this.hasReachedEndOfResults,
    this.isContentShared,
    this.isSearch,
    this.searchResults,
    this.error,
  });

  factory SearchState.initial() {
    return SearchState(
      isLoading: false,
      hasReachedEndOfResults: false,
      isContentShared: false,
      isSearch: true,
      searchResults: [],
      error: "",
    );
  }

  factory SearchState.loading() {
    return SearchState(
      isLoading: true,
      hasReachedEndOfResults: false,
      isContentShared: false,
      isSearch: true,
      searchResults: [],
      error: "",
    );
  }

  factory SearchState.failure(String error) {
    return SearchState(
      isLoading: false,
      hasReachedEndOfResults: false,
      isContentShared: false,
      isSearch: true,
      searchResults: [],
      error: error,
    );
  }

  factory SearchState.success(List<VideoModel> searchResults) {
    return SearchState(
      isLoading: false,
      hasReachedEndOfResults: false,
      isContentShared: false,
      isSearch: true,
      searchResults: searchResults,
      error: "",
    );
  }

  factory SearchState.endOfResults(List<VideoModel> searchResults) {
    return SearchState(
      isLoading: false,
      hasReachedEndOfResults: true,
      isContentShared: false,
      isSearch: true,
      searchResults: searchResults,
      error: "",
    );
  }

  factory SearchState.shared(List<VideoModel> viewed) {
    return SearchState(
      isLoading: false,
      hasReachedEndOfResults: true,
      isContentShared: true,
      isSearch: false,
      searchResults: viewed,
      error: "",
    );
  }

  bool get isInitial => !isLoading && searchResults.isEmpty && error == "";

  bool get isSuccessful =>
      !isLoading && searchResults.isNotEmpty && error == "";

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is SearchState &&
        o.isLoading == this.isLoading &&
        o.hasReachedEndOfResults == this.hasReachedEndOfResults &&
        o.searchResults == this.searchResults &&
        o.error == this.error) return true;
    return false;
  }

  @override
  int get hashCode => searchResults.hashCode;
}

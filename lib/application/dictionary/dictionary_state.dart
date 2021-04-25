import 'package:limapp/application/state.dart';
import 'package:limapp/models/dictionary/dictionary_model.dart';

class DictionaryState implements ApplicationState {
  JpWordModel currentWord;
  bool isLoading;
  String error;

  DictionaryState({this.currentWord, this.isLoading, this.error});

  factory DictionaryState.initial() {
    return DictionaryState(currentWord: null, isLoading: false, error: "");
  }

  factory DictionaryState.loading() {
    return DictionaryState(currentWord: null, isLoading: true, error: "");
  }

  factory DictionaryState.loaded(JpWordModel word) {
    return DictionaryState(currentWord: word, isLoading: false, error: "");
  }

  factory DictionaryState.error(String error) {
    return DictionaryState(currentWord: null, isLoading: false, error: error);
  }

  bool hasLoaded() => currentWord != null && !isLoading;
}

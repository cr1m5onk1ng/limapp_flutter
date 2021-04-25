import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/services/dictionary_service.dart';
import 'package:limapp/services/search_api_service.dart';

import '../../services/dictionary_service.dart';
import 'dictionary_state.dart';

class DictionaryStateNotifier extends StateNotifier<DictionaryState> {
  DictionaryService service;

  DictionaryStateNotifier(this.service) : super(DictionaryState.initial());

  Future<void> searchWord(String word) async {
    service.ensureStoriesInitialized();
    service.ensureDictionaryInitialized();
    state = DictionaryState.loading();
    try {
      final dictModel = await service.getSearchResult(word);
      state = DictionaryState.loaded(dictModel);
    } on WordNotFoundError catch (error) {
      state = DictionaryState.error(error.message);
    } on SearchError catch (error) {
      state = DictionaryState.error(error.message);
    }
  }
}

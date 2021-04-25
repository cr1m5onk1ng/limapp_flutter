import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/dictionary/dictionary_state_notifier.dart';
import 'package:limapp/services/dictionary_service.dart';

final dictionaryServiceProvider = Provider<DictionaryService>((ref) {
  return DictionaryService();
});

final dictionaryStateNotifierProvider =
    StateNotifierProvider<DictionaryStateNotifier>((ref) {
  final DictionaryService service = ref.watch(dictionaryServiceProvider);
  return DictionaryStateNotifier(service);
});

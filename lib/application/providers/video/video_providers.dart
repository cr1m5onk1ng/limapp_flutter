import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/search/search_state_notifier.dart';
import 'package:limapp/services/search_api_service.dart';

final searchStateNotifierProvider =
    StateNotifierProvider.autoDispose<SearchStateNotifier>(
        (ref) => SearchStateNotifier(ref.watch(searchApiProvider)));

final searchApiProvider = Provider<SearchService>((ref) => SearchService());

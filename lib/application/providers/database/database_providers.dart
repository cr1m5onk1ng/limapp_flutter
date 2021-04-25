import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:limapp/services/database_service.dart';

final videosBoxProvider = FutureProvider.autoDispose<Box>((ref) async {
  final videoBox = await Hive.openBox('videos');

  ref.onDispose(() async => await videoBox?.close());
  return videoBox;
});

final articlesBoxProvider = FutureProvider.autoDispose<Box>((ref) async {
  final articleBox = await Hive.openBox('articles');

  ref.onDispose(() async => await articleBox?.close());
  return articleBox;
});

final databaseServiceProvider =
    Provider<DatabaseService>((_) => DatabaseService());

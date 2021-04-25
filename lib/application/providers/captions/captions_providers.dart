import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/player/caption_state_notifier.dart';
import 'package:limapp/services/caption_service.dart';

final captionStateNotifierProvider =
    StateNotifierProvider.autoDispose<CaptionStateNotifier>((ref) {
  return CaptionStateNotifier(CaptionService());
});

final activeCaptionProvider = StateProvider.autoDispose<int>((_) => 0);

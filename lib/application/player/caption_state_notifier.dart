import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/services/caption_service.dart';
import 'package:limapp/models/captions/captions_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'caption_state.dart';

class CaptionStateNotifier extends StateNotifier<CaptionState> {
  final CaptionService service;
  CaptionStateNotifier(this.service) : super(CaptionState.initial());

  Future<void> loadCaptions(String videoId, String lang) async {
    await service.checkInitialized(videoId);
    state = CaptionState.loading();
    try {
      final List<ClosedCaption> captions = service.data.track.captions;
      var captionsMap = LinkedHashMap<int, List<Caption>>();
      for (int i = 0; i < captions.length; i++) {
        var element = captions[i];
        final capt = Caption(closedCaption: element, index: i);
        if (captionsMap.containsKey(element.offset.inSeconds)) {
          captionsMap.update(
              element.offset.inSeconds, (value) => value + [capt]);
        } else {
          captionsMap.putIfAbsent(element.offset.inSeconds, () => [capt]);
        }
      }
      state = CaptionState.loaded(captionsMap);
    } on NoTrackFoundException catch (e) {
      state = CaptionState.error(e.message);
    }
  }
}

import 'dart:collection';
import 'package:limapp/application/state.dart';
import 'package:limapp/models/captions/captions_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CaptionState implements ApplicationState {
  // the state is the list of closed captions
  // a certain closed captions defined by a certain start time is active at that moment
  // all the others are inactive
  // every closed captions is indexed by it's start time

  LinkedHashMap<int, List<Caption>> captions;
  List<Caption> captionsList;
  bool isLoading;
  String error;

  CaptionState({this.captions, this.captionsList, this.isLoading, this.error});

  factory CaptionState.initial() {
    return CaptionState(
      captions: LinkedHashMap<int, List<Caption>>(),
      captionsList: [],
      isLoading: false,
      error: "",
    );
  }

  factory CaptionState.loading() {
    return CaptionState(
      captions: LinkedHashMap<int, List<Caption>>(),
      captionsList: [],
      isLoading: true,
      error: "",
    );
  }

  factory CaptionState.loaded(LinkedHashMap<int, List<Caption>> captions) {
    List<Caption> flat = [];
    captions.values.forEach((element) {
      flat.addAll(element.toList());
    });
    return CaptionState(
      captions: captions,
      captionsList: flat,
      isLoading: false,
      error: "",
    );
  }

  factory CaptionState.error(String error) {
    return CaptionState(
      captions: LinkedHashMap<int, List<Caption>>(),
      captionsList: [],
      isLoading: false,
      error: error,
    );
  }
}

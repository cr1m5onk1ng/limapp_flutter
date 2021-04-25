import 'dart:typed_data';

import 'package:limapp/application/state.dart';
import 'package:uuid/uuid.dart';

class ImageState implements ApplicationState {
  final Uint8List image;
  final String id;

  ImageState({this.image, this.id});

  factory ImageState.inital() {
    return ImageState(image: null, id: null);
  }

  factory ImageState.loaded(Uint8List image) {
    return ImageState(image: image, id: Uuid().v1());
  }
}

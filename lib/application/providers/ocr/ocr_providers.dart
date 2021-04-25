import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/ocr/image_state_notifier.dart';
import 'package:limapp/application/ocr/ocr_state_notifier.dart';

final screenshotProvider =
    StateNotifierProvider<ImageStateNotifier>((_) => ImageStateNotifier());

final ocrStateNotifierProvider =
    StateNotifierProvider<OcrTextStateNotifier>((ref) {
  return OcrTextStateNotifier();
});

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/ocr/image_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ImageStateNotifier extends StateNotifier<ImageState> {
  ImageStateNotifier() : super(ImageState.inital());

  Future<void> takeScreenshot(ScreenshotController controller) async {
    state = ImageState.inital();
    final image = await controller.capture();
    state = ImageState.loaded(image);
    final directory = (await getApplicationDocumentsDirectory()).path;
    controller.captureAndSave(directory, fileName: state.id);
  }
}

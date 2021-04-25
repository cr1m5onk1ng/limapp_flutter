import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/ocr/ocr_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:uuid/uuid.dart';

class OcrTextStateNotifier extends StateNotifier<OcrTextState> {
  OcrTextStateNotifier() : super(OcrTextState.initial());

  Future<void> extractText(ScreenshotController controller) async {
    state = OcrTextState.scanning();
    String directory = (await getApplicationDocumentsDirectory()).path;
    print("###############DIRECTORY: $directory##################");
    final imageId = Uuid().v1();
    await controller.captureAndSave(directory, fileName: imageId);
    final String filepath = '$directory/$imageId';
    print("############FILEPATH: $filepath###############");
    final text = await TesseractOcr.extractText(filepath);
    print("#################CAPTURED TEXT: $text###################");
    state = OcrTextState.done(text);
  }
}

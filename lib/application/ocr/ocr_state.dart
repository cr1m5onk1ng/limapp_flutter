import 'package:limapp/application/state.dart';

class OcrTextState implements ApplicationState {
  final bool scanning;
  final String text;

  OcrTextState({this.scanning, this.text});

  factory OcrTextState.initial() {
    return OcrTextState(scanning: false, text: "");
  }

  factory OcrTextState.scanning() {
    return OcrTextState(scanning: true, text: "");
  }

  factory OcrTextState.done(String text) {
    return OcrTextState(scanning: false, text: text);
  }
}

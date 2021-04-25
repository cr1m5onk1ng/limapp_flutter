import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:limapp/application/providers/captions/captions_providers.dart';
import 'package:limapp/application/providers/ocr/ocr_providers.dart';
import 'package:limapp/models/captions/captions_model.dart';
import 'package:limapp/widgets/captions/captions_container.dart';
import 'package:limapp/widgets/player/player_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ScreenshotController _screenshotController = ScreenshotController();
  Uint8List _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void takeScreenshot() async {
    final screenshot = await _screenshotController.capture();
    setState(() {
      _image = screenshot;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white70,
        child:
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height / 3,
            Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Center(child: Text("Text to copy")),
            ),
            RaisedButton(onPressed: () => takeScreenshot()),
            SizedBox(height: 10),
            Container(
              child: _image == null
                  ? Center(child: Text("Copy text here"))
                  : Image.memory(_image),
            )
            /*
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height / 2,
                child: CaptionsContainerV2(
                  _youtubeController,
                  _captionsScrollController,
                  widget.videoId,
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

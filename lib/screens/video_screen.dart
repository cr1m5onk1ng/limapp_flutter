import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:limapp/application/providers/captions/captions_providers.dart';
import 'package:limapp/application/providers/ocr/ocr_providers.dart';
import 'package:limapp/models/captions/captions_model.dart';
import 'package:limapp/screens/home_screen.dart';
import 'package:limapp/widgets/captions/captions_container.dart';
import 'package:limapp/widgets/player/player_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;

  VideoScreen(this.videoId);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _youtubeController;
  AutoScrollController _captionsScrollController;
  //ScreenshotController _screenshotController = ScreenshotController();

  Future _scrollToIndex(int index) async {
    await _captionsScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
  }

  void _captionsLogic(Duration position) {
    final captionState = context.read(captionStateNotifierProvider.state);
    final activeCaption = context.read(activeCaptionProvider);
    if (position != null &&
        captionState.captions.containsKey(position.inSeconds)) {
      List<Caption> actualCaptions = captionState.captions[position.inSeconds];
      int index;
      if (actualCaptions.length == 1) {
        index = actualCaptions.first.index;
      } else {
        actualCaptions.forEach((element) {
          if (position.inMilliseconds >=
                  element.closedCaption.offset.inMilliseconds &&
              position.inMilliseconds <=
                  element.closedCaption.offset.inMilliseconds +
                      element.closedCaption.duration.inMilliseconds) {
            index = element.index;
          }
        });
      }
      // this should improve the rebuild rate
      if (index != activeCaption.state) {
        activeCaption.state = index;
        _scrollToIndex(index);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      params: YoutubePlayerParams(
        mute: false,
        enableCaption: false,
        showFullscreenButton: false,
      ),
    );
    _captionsScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    context
        .read(captionStateNotifierProvider)
        .loadCaptions(widget.videoId, "ja");
    _youtubeController.listen((event) {
      if (event.isReady) {
        _captionsLogic(event.position);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    }
                  }),
              PlayerFrame(_youtubeController),
              SizedBox(height: 5),
              // INSERT HERE A TAB BAR WITH CAPTIONS AND COMMENTS (with IndexedStack widget)
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CaptionsContainer(
                    _youtubeController,
                    _captionsScrollController,
                    widget.videoId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

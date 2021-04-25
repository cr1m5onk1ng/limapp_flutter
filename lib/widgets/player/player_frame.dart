import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerFrame extends StatelessWidget {
  final YoutubePlayerController videoController;

  PlayerFrame(this.videoController);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: videoController,
      aspectRatio: 16 / 9,
    );
  }
}

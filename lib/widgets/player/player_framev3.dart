/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/captions/captions_providers.dart';
import 'package:limapp/widgets/captions/captions_context_menu.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerFrameV3 extends StatelessWidget {
  final YoutubePlayerController videoController;

  PlayerFrameV3(this.videoController);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayerIFrame(
          controller: videoController,
          aspectRatio: 16 / 9,
        ),
        Consumer(
          builder: (context, watch, child) {
            final captionState = watch(captionStateNotifierProvider.state);
            final activeCaptionState = watch(activeCaptionProvider);
            final text =
                activeCaptionState.state < captionState.captionsList.length
                    ? captionState.captionsList[activeCaptionState.state].text
                    : "";
            return Container(
              color: Colors.black45,
              //height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              /*activeCaptionState.state == index
                    ? Colors.redAccent
                    : Colors.black45 */
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CaptionTextContainer(text),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

*/

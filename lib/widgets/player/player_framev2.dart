/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/captions/captions_providers.dart';
import 'package:limapp/widgets/captions/captions_context_menu.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerFrameV2 extends StatelessWidget {
  final YoutubePlayerController videoController;

  PlayerFrameV2(this.videoController);

  @override
  Widget build(BuildContext context) {
    print("BUILD CALLED !!!!!!!!!!!!!!!");
    return Stack(
      children: [
        YoutubePlayerIFrame(
          controller: videoController,
        ),
        Positioned(
          top: 10,
          right: MediaQuery.of(context).size.width / 2 - 150,
          //left: MediaQuery.of(context).size.width / 2 + 64,
          child: Consumer(
            builder: (context, watch, child) {
              print("BUILDER CALLED !!!!!!!!!!!!!!!");
              final captionState = watch(captionStateNotifierProvider.state);
              final activeCaptionState = watch(activeCaptionProvider);
              final text =
                  activeCaptionState.state < captionState.captionsList.length
                      ? captionState.captionsList[activeCaptionState.state].text
                      : "";
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black26,
                ),

                width: 300,
                padding: const EdgeInsets.all(5),
                //margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(child: CaptionTextContainer(text)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

*/

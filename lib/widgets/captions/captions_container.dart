import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/captions/captions_providers.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'captions_context_menu.dart';

class CaptionsContainer extends StatelessWidget {
  final YoutubePlayerController playerController;
  final AutoScrollController captionsScrollController;
  final String videoId;

  CaptionsContainer(
    this.playerController,
    this.captionsScrollController,
    this.videoId,
  );

  @override
  Widget build(BuildContext context) {
    // we set the state based on the current video player position
    return Consumer(
      builder: (context, watch, child) {
        final captionState = watch(captionStateNotifierProvider.state);
        return captionState.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  controller: captionsScrollController,
                  children: captionState.captionsList
                      .map(
                        (caption) => AutoScrollTag(
                          key: ValueKey(caption.index),
                          controller: captionsScrollController,
                          index: caption.index,
                          child: Consumer(
                            builder: (context, watch, child) {
                              final index = caption.index;
                              final captiontext =
                                  index < captionState.captionsList.length
                                      ? captionState.captionsList[index]
                                          .closedCaption.text
                                      : "";
                              final activeCaptionState =
                                  watch(activeCaptionProvider);
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: activeCaptionState.state == index
                                        ? Colors.grey[400].withOpacity(0.8)
                                        : const Color(0xFFF5F5F5),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 211, 211, 211),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CaptionTextContainer(captiontext),
                                    ),
                                    InkWell(
                                      onTap: () => playerController.seekTo(
                                          captionState.captionsList[index]
                                              .closedCaption.offset),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          CupertinoIcons.play_circle,
                                          color:
                                              activeCaptionState.state == index
                                                  ? Colors.red.shade600
                                                  : Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:limapp/models/video/video_model.dart';
import 'package:limapp/screens/video_screen.dart';

class VideoItem extends StatelessWidget {
  final VideoModel video;

  VideoItem(this.video);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return VideoScreen(video.id);
              },
            ),
          );
        },
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  video.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

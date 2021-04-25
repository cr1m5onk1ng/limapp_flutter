import 'package:limapp/application/state.dart';
import 'package:limapp/models/video/video_model.dart';

abstract class VideoState implements ApplicationState {}

class VideoInitial implements VideoState {
  const VideoInitial();
}

class VideoLoading implements VideoState {
  const VideoLoading();
}

class VideoLoaded implements VideoState {
  final List<VideoModel> videos;

  const VideoLoaded(this.videos);

  @override
  bool operator ==(Object o) {
    if (identical(o, this)) {
      return true;
    }
    return o is VideoLoaded && this.videos == o.videos;
  }

  @override
  int get hashCode => videos.hashCode;
}

class VideoError implements VideoState {
  final String message;
  const VideoError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is VideoError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

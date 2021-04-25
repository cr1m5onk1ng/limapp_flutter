import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Caption {
  ClosedCaption closedCaption;
  int index;

  Caption({this.closedCaption, this.index});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is Caption && this.closedCaption == o.closedCaption) return true;
    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => closedCaption.hashCode;
}

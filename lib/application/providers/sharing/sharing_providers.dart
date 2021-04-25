import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedTextProvider = StateProvider.autoDispose<String>((_) => "");

final sentTextProvider = StateProvider<String>((_) => "");

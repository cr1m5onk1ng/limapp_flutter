import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/reader/metadata_service.dart';

final metadataProvider = Provider<MetadataService>((_) => MetadataService());

final isSharedProvider = StateProvider.autoDispose<bool>((_) => false);

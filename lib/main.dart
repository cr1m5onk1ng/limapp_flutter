import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:limapp/screens/article_view.dart';
import 'package:limapp/screens/articles_screen.dart';
import 'package:limapp/screens/home_screen.dart';
import 'package:limapp/screens/navigation_screen.dart';
import 'package:limapp/screens/video_screen.dart';
import 'package:limapp/utilities/utils.dart';
import 'package:limapp/widgets/app/app_retain.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import './models/video/video_hive.dart';
import 'application/providers/database/database_providers.dart';
import 'application/providers/reader/reader_providers.dart';
import 'models/reader/article_hive.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(VideoHiveModelAdapter());
  Hive.registerAdapter(ArticleAdapter());
  //await Hive.deleteBoxFromDisk('videos');
  //await Hive.deleteBoxFromDisk('articles');
  await initBoxes();
  runApp(ProviderScope(
    child: AppRetainWidget(child: MyApp()),
  ));
}

Future<void> initBoxes() async {
  await Hive.openBox<VideoHiveModel>('videos',
      keyComparator: (a, b) => -a.compareTo(b));
  await Hive.openBox<Article>('articles',
      keyComparator: (a, b) => -a.compareTo(b));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        brightness: Brightness.light,
        //primaryColor: Colors.red.shade600,
        //accentColor: Colors.redAccent.shade400,
      ),
      home: NavigationScreen(),
    );
  }
}

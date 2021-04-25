import 'dart:async';
import 'dart:math';

import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:limapp/application/providers/database/database_providers.dart';
import 'package:limapp/application/providers/dictionary/dictionary_providers.dart';
import 'package:limapp/application/providers/reader/reader_providers.dart';
import 'package:limapp/screens/articles_screen.dart';
import 'package:limapp/screens/search_screen.dart';
import 'package:limapp/screens/video_screen.dart';
import 'package:limapp/utilities/swatches.dart';
import 'package:limapp/utilities/utils.dart';
import 'package:limapp/widgets/dictionary/dictionary_popup.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'article_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        if (value != null) {
          if (value.contains('youtu.be')) {
            //print("YOUTUBE URL FROM ALREADY OPEN SHARE INTENT $value");
            final videoId = urlToVideoId(value);
            context.read(databaseServiceProvider).addVideo(videoId);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VideoScreen(videoId),
                ),
              );
            });
          } else {
            //print("ARTICLE URL FROM ALREADY OPEN SHARE INTENT $value");
            final isShared = context.read(isSharedProvider);
            isShared.state = true;
            context.read(databaseServiceProvider).addArticle(value);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ArticleView(url: value),
                ),
              );
            });
          }
        }
      },
      onError: (err) {
        print("getLinkStream ERROR!: $err");
      },
    );

    // Initializing subscription for shared text / urls when the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        if (value.contains('youtu.be')) {
          //print("YOUTUBE URL FROM STARTUP SHARE INTENT $value");
          final videoId = urlToVideoId(value);
          context.read(databaseServiceProvider).addVideo(videoId);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VideoScreen(videoId),
              ),
            );
          });
        } else {
          //print("ARTICLE URL FROM STARTUP SHARE INTENT $value");
          final isShared = context.read(isSharedProvider);
          isShared.state = true;
          context.read(databaseServiceProvider).addArticle(value);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArticleView(url: value),
              ),
            );
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> tags = ["民間船", "海難審判庁", "構成", "調査委時代", "民間船", "民間船"];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: [
            SizedBox(height: 60),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://pbs.twimg.com/profile_images/711593363624095747/lJV3XX-H.jpg"),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "NaLa",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SearchScreen())),
                      title: Text(
                        "Videos",
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      leading: Icon(
                        MdiIcons.youtube,
                        size: 60,
                        color: Colors.red.shade600,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ArticlesScreen())),
                      title: Text(
                        "Articles",
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      leading: Icon(
                        MdiIcons.web,
                        size: 60,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ArticlesScreen())),
                      title: Text(
                        "Reader",
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      leading: Icon(
                        MdiIcons.library,
                        size: 60,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ].vStack(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: VxAnimatedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.heightBox,
              AppBar(
                title: 'NaLa'.text.xl4.semiBold.yellow200.make(),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              40.heightBox,
              "Words you might forget".text.white.make().p20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: _ForgetWordsList(
                        colors: Swatches.forgetWordsColors,
                        words: tags,
                      ),
                    ),
                  ),
                ],
              ),
              40.heightBox,
              VxTextField(
                borderType: VxTextFieldBorderType.none,
                borderRadius: 18,
                hint: "Search for words or sentences",
                fillColor: Vx.gray200.withOpacity(0.3),
                contentPaddingTop: 13,
                autofocus: false,
                onSubmitted: (text) {
                  context
                      .read(dictionaryStateNotifierProvider)
                      .searchWord(text);
                  EasyPopup.show(
                    context,
                    DictionaryPopUp(),
                    darkEnable: true,
                  );
                },
                prefixIcon: Icon(Icons.search_outlined, color: Colors.white),
              )
                  .customTheme(
                      themeData: ThemeData(
                    brightness: Brightness.dark,
                  ))
                  .cornerRadius(10)
                  .p16(),
            ],
          ),
        )
            .size(context.screenWidth, context.screenHeight)
            .withGradient(
              LinearGradient(
                colors: [Colors.red.shade600, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
            .make(),
      ),
    );
  }
}

class _ForgetWordsList extends StatelessWidget {
  final List<Color> colors;
  final int maxLength;
  final List<String> words;

  const _ForgetWordsList({Key key, this.colors, this.maxLength, this.words})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: words.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context
                  .read(dictionaryStateNotifierProvider)
                  .searchWord(words[index]);
              EasyPopup.show(
                context,
                DictionaryPopUp(),
                cancelable: true,
                darkEnable: true,
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(26),
                ),
                color: Colors.white.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 5),
              child: Text(
                words[index],
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 22,
                  color: colors[random.nextInt(colors.length)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

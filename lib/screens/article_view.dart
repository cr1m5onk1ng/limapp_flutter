import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/dictionary/dictionary_providers.dart';
import 'package:limapp/screens/home_screen.dart';
import 'package:limapp/widgets/dictionary/dictionary_popup.dart';

class ArticleView extends StatefulWidget {
  final String url;

  const ArticleView({Key key, this.url}) : super(key: key);
  @override
  _ArticleViewState createState() => new _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
            androidId: 1,
            iosId: "1",
            title: "Search in dictionary",
            action: () async {
              final text = await webView.getSelectedText();
              final dictionaryStateNotifier =
                  context.read(dictionaryStateNotifierProvider);
              dictionaryStateNotifier.searchWord(text);
              EasyPopup.show(
                context,
                DictionaryPopUp(),
                darkEnable: true,
              );
            },
          )
        ],
        onCreateContextMenu: (hitTestResult) async {},
        onHideContextMenu: () {},
        onContextMenuActionItemClicked: (contextMenuItemClicked) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              color: Colors.black,
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
                color: Colors.blue,
                child: progress < 1.0
                    ? LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                      )
                    : SizedBox.shrink()),
            Expanded(
              child: Container(
                child: InAppWebView(
                  initialUrl: widget.url,
                  contextMenu: contextMenu,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

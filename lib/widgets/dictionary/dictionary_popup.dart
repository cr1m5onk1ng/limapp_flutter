import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/dictionary/dictionary_providers.dart';
import 'package:limapp/widgets/dictionary/word_card.dart';

class DictionaryPopUp extends StatelessWidget with EasyPopupChild {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final dictionaryState = watch(dictionaryStateNotifierProvider.state);
        return dictionaryState.hasLoaded()
            ? Positioned(
                bottom: 0,
                child: WordCard(),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  dismiss() {}
}

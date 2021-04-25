import 'dart:math';

import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/dictionary/dictionary_providers.dart';

import 'package:limapp/models/dictionary/dictionary_model.dart';
import 'package:limapp/utilities/swatches.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import "./kanji_details.dart";

class WordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        color: Swatches.dictionaryBackgrounds[
            random.nextInt(Swatches.dictionaryBackgrounds.length)],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadowColor: Colors.black,
        child: Stack(children: [
          Positioned(
            top: 15,
            right: 20,
            child: IconButton(
              icon: Icon(MdiIcons.close),
              onPressed: () {
                EasyPopup.pop(context);
              },
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              final dictionaryState =
                  watch(dictionaryStateNotifierProvider.state);
              return dictionaryState.currentWord.data.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Center(
                        child: Text(
                          'Oops.\n No word found.\n Blame the API',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dictionaryState.currentWord.data.length,
                      itemBuilder: (context, index) {
                        return WordBox(
                          data: dictionaryState.currentWord.data[index],
                          kanjis: dictionaryState.currentWord.kanji,
                        );
                      },
                    );
            },
          ),
        ]),
      ),
    );
  }
}

class WordBox extends StatelessWidget {
  final Data data;
  final Map<String, KanjiModel> kanjis;

  const WordBox({Key key, @required this.data, @required this.kanjis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = [];
    if (data.jlpt.isNotEmpty)
      tags.add(Tag(
        tag: "${data.jlpt}",
        textColor: Colors.black54,
        boxColor: Colors.grey[200],
      ));
    if (data.isCommon)
      tags.add(Tag(
        tag: "common",
        textColor: Colors.black54,
        boxColor: Colors.green[200],
      ));
    return Container(
      width: MediaQuery.of(context).size.width - 2 * 64,
      padding: EdgeInsets.only(left: 32, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              //Reading
              data.readings.isNotEmpty
                  ? Text(
                      data.readings.first,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff47455f),
                      ),
                    )
                  : SizedBox.shrink(),
              //Word
              _WordRow(word: data.slug, kanji: kanjis),
              //JLPT
              tags.isNotEmpty ? TagList(tags: tags) : SizedBox.shrink(),
              SizedBox(height: 8),
              //DEFINITIONS
            ] +
            data.senses
                .asMap()
                .map(
                  (int index, Sense sense) {
                    return MapEntry(
                      index,
                      _DefinitionRow(
                        definitions: sense.definitions,
                        tags: sense.tags,
                        pos: sense.pos,
                      ),
                    );
                  },
                )
                .values
                .toList(),
      ),
    );
  }
}

Widget _buildCharContainer(BuildContext context, String char) {
  return _CharContainer(
    char: char,
    underline: false,
  );
}

Widget _buildKanjiContainer(BuildContext context, KanjiModel kanjiModel) {
  return Hero(
    tag: kanjiModel.kanji,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => KanjiScreen(kanjiModel),
          ),
        );
      },
      child: _CharContainer(
        char: kanjiModel.kanji,
        underline: true,
      ),
    ),
  );
}

class _CharContainer extends StatelessWidget {
  final String char;
  final bool underline;

  _CharContainer({this.char, this.underline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Text(
        char,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontFamily: 'Avenir',
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: const Color(0xff47455f),
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final String word;
  final Map<String, KanjiModel> kanji;

  _WordRow({@required this.word, @required this.kanji});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: word.characters.map((e) {
          return kanji.containsKey(e)
              ? _buildKanjiContainer(context, kanji[e])
              : _buildCharContainer(context, e);
        }).toList(),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String tag;
  final Color textColor;
  final Color boxColor;
  final double fontSize;

  const Tag({Key key, this.tag, this.textColor, this.boxColor, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(offset: Offset(2, 2), color: Colors.black38),
        ],
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontFamily: 'Avenir',
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  //final Sense sense;
  final List<Tag> tags;

  const TagList({Key key, this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final merged = sense.tags + sense.pos;
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return tags[index];
        },
      ),
    );
  }
}

class _DefinitionRow extends StatelessWidget {
  final List<String> definitions;
  final List<String> tags;
  final List<String> pos;

  const _DefinitionRow({
    Key key,
    this.definitions,
    this.tags,
    this.pos,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Tag> tagsList = tags
        .map(
          (e) => Tag(
            tag: e,
            textColor: Colors.black54,
            boxColor: Colors.red[200],
          ),
        )
        .toList();
    List<Tag> posList = pos
        .map(
          (e) => Tag(
            tag: e,
            textColor: Colors.black54,
            boxColor: Colors.blue[200],
          ),
        )
        .toList();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
              TagList(tags: tagsList + posList),
              SizedBox(height: 5),
            ] +
            definitions
                .asMap()
                .map(
                  (i, definition) => MapEntry(
                    i,
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Text(
                        '${i + 1}. $definition',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff47455f),
                        ),
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
      ),
    );
  }
}

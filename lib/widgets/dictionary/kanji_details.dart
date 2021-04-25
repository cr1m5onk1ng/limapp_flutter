import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:limapp/models/dictionary/dictionary_model.dart';
import 'package:limapp/widgets/dictionary/word_card.dart';

class _DataBox extends StatelessWidget {
  final List<String> data;
  final String title;
  final double fontSize;

  const _DataBox({Key key, this.title, this.data, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff47455f),
                ),
              ),
              const SizedBox(height: 10),
            ] +
            data
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff47455f),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _KanjiMeanings extends StatelessWidget {
  final KanjiModel kanjiModel;

  _KanjiMeanings(this.kanjiModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _DataBox(
                title: 'Meanings',
                data: kanjiModel.meanings,
                fontSize: 18,
                //height: double.infinity,
              ),
            ),
            const SizedBox(width: 20),
            _DataBox(
              title: 'Kunyomi',
              data: kanjiModel.kunyomi,
              fontSize: 14,
              //height: double.infinity,
            ),
            const SizedBox(width: 20),
            _DataBox(
              title: 'Onyomi',
              data: kanjiModel.onyomi,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class Tags extends StatelessWidget {
  final List<Tag> tags;

  const Tags({Key key, this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class KanjiScreen extends StatelessWidget {
  final KanjiModel kanji;

  KanjiScreen(this.kanji);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      //KANJI
                      Text(
                        kanji.kanji,
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 56,
                          color: const Color(0xff47455f),
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      //TAGS
                      Tags(
                        tags: [
                          Tag(
                            tag: "jlptn-${kanji.jlpt}",
                            textColor: Colors.black54,
                            boxColor: Colors.blue[200],
                          ),
                          Tag(
                            tag: "frequency: ${kanji.frequency}",
                            textColor: Colors.black54,
                            boxColor: Colors.green[200],
                          ),
                          Tag(
                            tag: "grade: ${kanji.grade}",
                            textColor: Colors.black54,
                            boxColor: Colors.red[200],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Story',
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 24,
                            color: const Color(0xff47455f),
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(color: Colors.black38),
                      const SizedBox(height: 16),
                      // Story Container
                      Container(
                        child: ReadMoreText(
                          kanji.story,
                          trimMode: TrimMode.Line,
                          colorClickableText: Colors.grey,
                          trimCollapsedText: 'show more',
                          trimExpandedText: 'show less',
                          moreStyle: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 28,
                            color: const Color(0xff868686),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(color: Colors.black38),
                      const SizedBox(height: 12),
                      _KanjiMeanings(kanji),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

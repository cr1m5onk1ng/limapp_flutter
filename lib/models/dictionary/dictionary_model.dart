class KanjiModel {
  final String kanji;
  final List<String> kunyomi;
  final List<String> onyomi;
  final List<String> meanings;
  final String story;
  final String frequency;
  final String jlpt;
  final String grade;

  KanjiModel({
    this.kanji,
    this.kunyomi,
    this.onyomi,
    this.meanings,
    this.story,
    this.frequency,
    this.jlpt,
    this.grade,
  });

  @override
  String toString() {
    return "Kanji[${this.kanji}]";
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is KanjiModel && this.kanji == o.kanji) return true;
    return false;
  }

  @override
  int get hashCode => this.kanji.hashCode;
}

class Data {
  final String slug;
  final bool isCommon;
  final String jlpt;
  final List<String> readings;
  final List<Sense> senses;

  Data({this.slug, this.isCommon, this.jlpt, this.readings, this.senses});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is Data && this.slug == o.slug) return true;
    return false;
  }

  @override
  int get hashCode => this.slug.hashCode;

  @override
  String toString() {
    return "Word[${this.slug}]";
  }
}

class Sense {
  final List<String> definitions;
  final List<String> pos;
  final List<String> tags;

  Sense({this.definitions, this.pos, this.tags});
}

class JpWordModel {
  final List<Data> data;
  final Map<String, KanjiModel> kanji;

  JpWordModel({
    this.data,
    this.kanji,
  });

  factory JpWordModel.empty() {
    return JpWordModel(
      data: [],
      kanji: Map(),
    );
  }

  factory JpWordModel.fromResponse(
      dynamic data, Map<String, KanjiModel> kanji) {
    // assuming data is RAW json
    var elements = data['data'] as List<dynamic>;
    if (elements.isEmpty) return JpWordModel.empty();
    List<Map<String, dynamic>> elementsList =
        new List<Map<String, dynamic>>.from(elements);
    final word = elementsList.first['slug'] as String;
    List<Data> dataList = [];
    elementsList.forEach(
      (element) {
        var slug = element['slug'] as String;
        if (slug.length == word.length) {
          var isCommon = element['is_common'];
          var jlpt = element['jlpt'];
          List<String> jlptList = new List<String>.from(jlpt);
          var jlptElement = jlptList.isNotEmpty ? jlptList.first : "";
          var japanese = element['japanese'];
          List<Map<String, dynamic>> japaneseMap =
              new List<Map<String, dynamic>>.from(japanese);
          List<String> readings = [];
          String jpWord = '';
          japaneseMap.forEach((element) {
            if (element.containsKey('reading'))
              readings.add(element['reading']);
            if (element.containsKey('word')) jpWord = element['word'];
          });
          if (slug.contains(RegExp(r'[a-z0-1]'))) {
            if (jpWord.isNotEmpty) {
              slug = jpWord;
            } else {
              slug = '';
            }
          }
          var senses = element['senses'];
          List<Map<String, dynamic>> sensesMap =
              new List<Map<String, dynamic>>.from(senses);
          List<Sense> sensesList = [];
          sensesMap.forEach(
            (element) {
              var definitions = element['english_definitions'];
              List<String> definitionsList = new List<String>.from(definitions);
              var pos = element['parts_of_speech'];
              List<String> posList = new List<String>.from(pos);
              var tags = element['tags'];
              List<String> tagsList = new List<String>.from(tags);
              sensesList.add(
                Sense(
                  definitions: definitionsList,
                  pos: posList,
                  tags: tagsList,
                ),
              );
            },
          );
          dataList.add(
            Data(
              slug: slug,
              isCommon: isCommon != null ? isCommon as bool : false,
              jlpt: jlptElement,
              readings: readings,
              senses: sensesList,
            ),
          );
        }
      },
    );

    return JpWordModel(
      data: dataList,
      kanji: kanji,
    );
  }

  @override
  String toString() {
    return "Word[${this.data}]; kanjis[${this.kanji}]";
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is JpWordModel && this.data == o.data) return true;
    return false;
  }

  @override
  int get hashCode => this.data.hashCode;
}

class NoWordFoundException implements Exception {
  final String message;

  NoWordFoundException(this.message);
}

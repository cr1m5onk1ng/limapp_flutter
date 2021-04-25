import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:limapp/models/dictionary/dictionary_model.dart';
import 'package:limapp/services/search_api_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class DictionaryService {
  final String _apiUrl;
  Map<String, KanjiModel> kanjiDict;
  Map<String, String> stories;

  DictionaryService()
      : _apiUrl = "https://jisho.org/api/v1/search/words?keyword=";

  Future<void> ensureDictionaryInitialized() async {
    if (this.kanjiDict == null) this.kanjiDict = await loadKanjiDictionary();
  }

  Future<void> ensureStoriesInitialized() async {
    if (this.stories == null) this.stories = await loadKanjiStories();
  }

  Future<Map<String, KanjiModel>> loadKanjiDictionary() async {
    final jsonString = await _loadKanjiJson();
    final jsonParsed = json.decode(jsonString);
    final dict = _loadKanjisDictionary(jsonParsed);
    assert(dict != null);
    return dict;
  }

  Future<Map<String, String>> loadKanjiStories() async {
    final jsonString = await _loadStoriesJson();
    final jsonParsed = json.decode(jsonString);
    final dict = _loadStories(jsonParsed);
    assert(dict != null);
    return dict;
  }

  List<KanjiModel> _textToKanjis(Map<String, KanjiModel> dict, String text) {
    List<KanjiModel> kanjis = [];
    text.runes.forEach((element) {
      var kanji = String.fromCharCode(element);
      if (dict.containsKey(kanji)) {
        kanjis.add(dict[kanji]);
      }
    });
    return kanjis;
  }

  List<KanjiModel> getKanjis(String text) {
    return text.isNotEmpty ? _textToKanjis(this.kanjiDict, text) : [];
  }

  Future<String> _loadKanjiJson() async {
    return await rootBundle.loadString('assets/kanjidic.json');
  }

  Future<String> _loadStoriesJson() async {
    return await rootBundle.loadString('assets/kanjistories.json');
  }

  Map<String, String> _loadStories(dynamic json) {
    var notes = json['notes'] as List<dynamic>;
    Map<String, String> storiesMap = HashMap();
    notes.forEach((element) {
      var story = element['fields'];
      List<String> storyList = new List<String>.from(story);
      storiesMap.putIfAbsent(storyList.first, () => storyList.last);
    });
    return storiesMap;
  }

  Map<String, KanjiModel> _loadKanjisDictionary(dynamic kanjisJson) {
    var kanjis = kanjisJson['words'];
    List<Map<String, dynamic>> kanjisList =
        new List<Map<String, dynamic>>.from(kanjis);

    Map<String, KanjiModel> dict = HashMap();
    kanjisList.forEach((element) {
      var kanji = element['kanji'] as String;
      var kunyomis = element['reading']['kun'];
      List<String> kunyomiList = new List<String>.from(kunyomis);
      var onyomis = element['reading']['on'];
      List<String> onyomiList = new List<String>.from(onyomis);
      var meanings = element['meaning'];
      List<String> meaningsList = new List<String>.from(meanings);
      var story = this.stories.containsKey(kanji) ? this.stories[kanji] : "";
      var freq = element['freq'] as String ?? "";
      var jlpt = element['jlpt'] as String ?? "";
      var grade = element['grade'];
      var retGrade = grade == 0 ? "" : element['grade'] as String;
      final model = KanjiModel(
        kanji: kanji,
        kunyomi: kunyomiList != null ? kunyomiList : [],
        onyomi: onyomiList != null ? onyomiList : [],
        meanings: meaningsList.isNotEmpty ? meaningsList : [],
        story: story,
        frequency: freq,
        jlpt: jlpt,
        grade: retGrade,
      );
      dict.putIfAbsent(kanji, () => model);
    });
    assert(dict.isNotEmpty);
    return dict;
  }

  Future<JpWordModel> getSearchResult(String word) async {
    await ensureStoriesInitialized();
    await ensureDictionaryInitialized();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptCharsetHeader: 'utf-8',
    };
    final urlQuery = _apiUrl + "$word";
    final urlEncoded = Uri.encodeFull(urlQuery);
    final response = await http.get(urlEncoded, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse.isEmpty) {
        throw WordNotFoundError("word was not found in the dictionary");
      }
      var data = jsonResponse['data'] as List<dynamic>;
      //var responseWord = data.isNotEmpty ? data.first['slug'] as String : "";

      var dictModel = JpWordModel.fromResponse(jsonResponse, kanjiDict);
      return dictModel;
    } else {
      throw SearchError("an error occured during connection with the service");
    }
  }
}

class WordNotFoundError implements Exception {
  final String message;

  WordNotFoundError(this.message);
}

class KanjiNotFoundError implements Exception {
  final String message;
  KanjiNotFoundError(this.message);
}

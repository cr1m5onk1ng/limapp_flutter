import 'package:flutter_riverpod/all.dart';
import '../../utilities/keys.dart';

abstract class Parameters {}

final apiParametersProvider = Provider<ApiParameters>((ref) => ApiParameters());

class ApiParameters implements Parameters {
  String relevanceLanguage;
  String type;
  String baseQuery;
  String pageToken;
  int maxResults;

  ApiParameters({
    this.relevanceLanguage: "ja",
    this.type: "video",
    this.baseQuery: "IGN japan",
    this.maxResults: 20,
  });

  Map<String, String> toParameters(String pageToken) {
    Map<String, String> parameters = {
      'part': 'snippet',
      'key': API_KEY,
      'pageToken': pageToken,
      'relevanceLanguage': this.relevanceLanguage,
      "q": this.baseQuery,
      'type': this.type,
      'maxResults': this.maxResults.toString(),
      'videoCaption': 'closedCaption',
    };
    return parameters;
  }

  set setLanguage(String lang) => this.relevanceLanguage = lang;

  set setType(String type) => this.type = type;

  set setMaxResults(int maxRes) => this.maxResults = maxRes;

  set setQuery(String query) => this.baseQuery = query;
}

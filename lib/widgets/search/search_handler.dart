import 'package:flutter/material.dart';

class SearchHandler extends SearchDelegate {
  String selectedResults;
  List<String> suggestions = [];
  Set<String> searched = {};

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResults),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (!searched.contains(query)) {
      suggestions.add(query);
    }
    return ListView.builder(
      itemCount: searched.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            selectedResults = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:limapp/application/providers/video/video_providers.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search videos',
        border: InputBorder.none,
        icon: Icon(
          Icons.search,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      onSubmitted: (searchQuery) {
        context
            .read(searchStateNotifierProvider)
            .fetchInitialResults(searchQuery);
      },
      controller: _controller,
      focusNode: _focusNode,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limapp/application/providers/video/video_providers.dart';
import 'package:limapp/models/models.dart';
import 'package:limapp/widgets/search/categories.dart';
import 'package:limapp/widgets/search/loader.dart';
import 'package:limapp/widgets/search/video_item.dart';
import '../application/search/search_state.dart';
import '../application/search/search_state_notifier.dart';
import '../widgets/search/initial_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scrollController = ScrollController();
  SearchBar searchBar;

  @override
  void initState() {
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        onSubmitted: (query) {
          context.read(searchStateNotifierProvider).fetchInitialResults(query);
        },
        buildDefaultAppBar: buildAppBar);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: Column(
          children: [
            /*
            CategoriesContainer(
              categories: ['technology', 'business', 'programming', 'travel'],
            ),
            */
            _buildSearchBody(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Videos',
        style: TextStyle(
          fontFamily: 'Avenir',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.red.shade600,
      actions: [
        Container(
          child: searchBar.getSearchAction(context),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _buildSearchBody() {
    return Consumer(
      builder: (context, watch, child) {
        final state = watch(searchStateNotifierProvider.state);
        final searchNotifier = watch(searchStateNotifierProvider);
        if (state.isInitial) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<VideoHiveModel>('videos').listenable(),
            builder: (context, Box<VideoHiveModel> box, widget) {
              final videos = new List<VideoHiveModel>.of(box.values);
              //videos.sort((a, b) => -a.dateAdded.compareTo(b.dateAdded));
              if (videos.isEmpty)
                return Center(
                  child: InitialScreen(message: "No video present."),
                );
              return _buildShared(videos);
            },
          );
        }

        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.isSuccessful) {
          return _buildResults(state, searchNotifier);
        } else {
          return InitialScreen(
            message: state.error,
          );
        }
      },
    );
  }

  Widget _buildShared(List<VideoModel> videos) {
    return Expanded(
      child: ListView.separated(
        itemCount: videos.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return VideoItem(videos[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
            color: Colors.grey[200],
          );
        },
      ),
    );
  }

  Widget _buildResults(SearchState state, SearchStateNotifier searchNotifier) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            _scrollController.position.extentAfter == 0) {
          searchNotifier.fetchNextResults();
        }
        return false;
      },
      child: Expanded(
        child: ListView.separated(
          itemCount: state.hasReachedEndOfResults
              ? state.searchResults.length
              : state.searchResults.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return index >= state.searchResults.length && !state.isContentShared
                ? Loader()
                : VideoItem(state.searchResults[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 1,
              color: Colors.grey[200],
            );
          },
        ),
      ),
    );
  }
}

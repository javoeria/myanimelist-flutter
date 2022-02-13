import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  final CustomSearchDelegate _delegate = CustomSearchDelegate();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      tooltip: 'Search anime',
      onPressed: () async {
        final Search? selected = await showSearch<Search>(
          context: context,
          delegate: _delegate,
        );
        if (selected != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeScreen(selected.malId, selected.title),
              settings: RouteSettings(name: 'AnimeScreen'),
            ),
          );
        }
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<Search> {
  CustomSearchDelegate({this.type = SearchType.anime});

  SearchType type;
  List<String> _suggestions = [];
  final Jikan jikan = Jikan();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      tooltip: 'Back',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query.length < 3) {
      _suggestions.clear();
      return _SuggestionList(
        history: true,
        suggestions: Provider.of<UserData>(context).history,
        onSelected: (String suggestion) {
          query = suggestion;
          showResults(context);
        },
      );
    } else {
      return FutureBuilder(
        future: jikan.search(query, type, custom: '&limit=10'),
        builder: (context, AsyncSnapshot<BuiltList<Search>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            BuiltList<Search> searchList = snapshot.data!;
            _suggestions = searchList.map((search) => search.title!).toList();
          }

          return _SuggestionList(
            history: false,
            suggestions: _suggestions,
            onSelected: (String suggestion) {
              query = suggestion;
              showResults(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty || query.length < 3) {
      return Center(child: Text('Minimum 3 letters'));
    }

    FirebaseAnalytics.instance.logSearch(searchTerm: query);
    Provider.of<UserData>(context, listen: false).addHistory(query);
    // String excludeHentai = '&genre=12&genre_exclude=0&order_by=members&sort=desc';
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kSearchPageSize,
        itemBuilder: (context, Search search, _) => _ResultList(search, type: type, searchDelegate: this),
        padding: const EdgeInsets.all(12.0),
        noItemsFoundBuilder: (context) {
          return ListTile(title: Text('No items found.'));
        },
        pageFuture: (pageIndex) => jikan.search(query, type, page: pageIndex! + 1),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      ];
    }
    return [];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(color: Colors.white54)),
      textTheme: theme.textTheme.copyWith(headline6: theme.textTheme.headline6!.copyWith(color: Colors.white)),
    );
  }
}

class _ResultList extends StatelessWidget {
  _ResultList(this.search, {required this.type, required this.searchDelegate});

  final Search search;
  final SearchType type;
  final SearchDelegate<Search> searchDelegate;
  final NumberFormat f = NumberFormat.decimalPattern();

  String get _episodesText {
    if (type == SearchType.anime) {
      String episodes = search.episodes == 0 ? '?' : search.episodes.toString();
      return '($episodes eps)';
    } else if (type == SearchType.manga) {
      String volumes = search.volumes == 0 ? '?' : search.volumes.toString();
      return '($volumes vols)';
    } else {
      throw 'SearchType Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    String score = search.score == 0.0 ? 'N/A' : search.score.toString();
    return InkWell(
      onTap: () {
        searchDelegate.close(context, search);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.network(
                    search.imageUrl,
                    width: kImageWidthS,
                    height: kImageHeightS,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(search.title!, style: Theme.of(context).textTheme.subtitle2),
                        Text(
                          search.synopsis ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${search.type} $_episodesText - $score',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${f.format(search.members)} members',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.history, required this.suggestions, required this.onSelected});

  final bool history;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: min(suggestions.length, 10),
      itemBuilder: (context, index) {
        final String suggestion = suggestions[index];
        if (history) {
          return ListTile(
            leading: Icon(Icons.history),
            title: Text(suggestion, style: Theme.of(context).textTheme.subtitle1),
            onTap: () {
              onSelected(suggestion);
            },
            onLongPress: () async {
              bool? action = await _historyDialog(context, suggestion);
              if (action == true) {
                Provider.of<UserData>(context, listen: false).removeHistory(suggestion);
              }
            },
          );
        } else {
          return ListTile(
            key: Key('suggestion_$index'),
            leading: Icon(Icons.search),
            title: Text(suggestion, style: Theme.of(context).textTheme.subtitle1),
            onTap: () {
              onSelected(suggestion);
            },
          );
        }
      },
    );
  }
}

Future<bool?> _historyDialog(BuildContext context, String suggestion) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('Clear $suggestion from your history?'),
        actions: <Widget>[
          TextButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

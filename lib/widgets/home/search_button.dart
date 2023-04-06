import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
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
        final Anime? selected = await showSearch<dynamic>(
          context: context,
          delegate: _delegate,
        );
        if (selected != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeScreen(selected.malId, selected.title, episodes: selected.episodes),
              settings: const RouteSettings(name: 'AnimeScreen'),
            ),
          );
        }
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({this.type = ItemType.anime});

  final ItemType type;
  final List<String> _suggestions = [];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      tooltip: 'Back',
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query.length < 3) {
      _suggestions.clear();
      return _SuggestionList(
        history: true,
        suggestions: Provider.of<UserData>(context).history,
        onSelected: (value) {
          query = value;
          showResults(context);
        },
      );
    } else {
      return FutureBuilder(
        future: type == ItemType.anime
            ? jikan.searchAnime(query: query, rawQuery: '&limit=10')
            : jikan.searchManga(query: query, rawQuery: '&limit=10'),
        builder: (context, AsyncSnapshot<BuiltList<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            BuiltList<dynamic> searchList = snapshot.data!;
            _suggestions.addAll(searchList.map((search) => search.title.toString()));
          }

          return _SuggestionList(
            history: false,
            suggestions: _suggestions,
            onSelected: (value) {
              query = value;
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
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kDefaultPageSize,
        itemBuilder: (context, search, _) => _ResultList(search, searchDelegate: this),
        padding: const EdgeInsets.all(12.0),
        noItemsFoundBuilder: (context) => ListTile(title: Text('No items found.')),
        pageFuture: (pageIndex) => type == ItemType.anime
            ? jikan.searchAnime(query: query, page: pageIndex! + 1)
            : jikan.searchManga(query: query, page: pageIndex! + 1),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
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
}

class _ResultList extends StatelessWidget {
  const _ResultList(this.search, {required this.searchDelegate});

  final dynamic search;
  final SearchDelegate searchDelegate;

  @override
  Widget build(BuildContext context) {
    String score = search.score == null ? 'N/A' : search.score.toString();
    return InkWell(
      onTap: () => searchDelegate.close(context, search),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Image.network(search.imageUrl, width: kImageWidthS, height: kImageHeightS, fit: BoxFit.cover),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Text>[
                  Text(search.title, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    search.synopsis ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${search.type ?? 'Unknown'} ${episodesText(search)} - $score',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${(search.members as int).decimal()} members',
                    style: Theme.of(context).textTheme.bodySmall,
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
        String suggestion = suggestions.elementAt(index);
        if (history) {
          return ListTile(
            leading: Icon(Icons.history),
            title: Text(suggestion, style: Theme.of(context).textTheme.bodyLarge),
            onTap: () => onSelected(suggestion),
            onLongPress: () async {
              bool? action = await _historyDialog(context, suggestion);
              if (action == true) Provider.of<UserData>(context, listen: false).removeHistory(suggestion);
            },
          );
        } else {
          return ListTile(
            key: Key('suggestion_$index'),
            leading: Icon(Icons.search),
            title: Text(suggestion, style: Theme.of(context).textTheme.bodyLarge),
            onTap: () => onSelected(suggestion),
          );
        }
      },
    );
  }
}

Future<bool?> _historyDialog(BuildContext context, String suggestion) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(suggestion),
        content: Text('Remove from search history?'),
        actions: <TextButton>[
          TextButton(
            child: Text('NO'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('YES'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
}

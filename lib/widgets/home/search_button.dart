import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:provider/provider.dart';

final NumberFormat f = NumberFormat.decimalPattern();

class SearchButton extends StatelessWidget {
  final _CustomSearchDelegate _delegate = _CustomSearchDelegate();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        final Search selected = await showSearch<Search>(
          context: context,
          delegate: _delegate,
        );
        if (selected != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnimeScreen(selected.malId, selected.title)));
        }
      },
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate<Search> {
  List<String> _suggestions = [];
  SearchType type = SearchType.anime;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == null || query.isEmpty || query.length < 3) {
      _suggestions.clear();
      return _SuggestionList(
        query: query,
        suggestions: Provider.of<UserData>(context).history,
        onSelected: (String suggestion) {
          query = suggestion;
          showResults(context);
        },
      );
    } else {
      return FutureBuilder(
        future: JikanApi().search(type, query: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            BuiltList<Search> searchList = snapshot.data;
            List<String> titleList = searchList.map((search) => search.title).toList();
            _suggestions = titleList;
          }

          return _SuggestionList(
            query: query,
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
    if (query == null || query.isEmpty || query.length < 3) {
      return Center(child: Text('Minimum 3 letters'));
    }

    Provider.of<UserData>(context).addHistory(query);
    return FutureBuilder(
      future: JikanApi().search(type, query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Search> searchList = snapshot.data;
        return _ResultList(
          type: type,
          searchList: searchList,
          searchDelegate: this,
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: better filter
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
    return null;
  }
}

class _ResultList extends StatelessWidget {
  _ResultList({this.type, this.searchList, this.searchDelegate});

  final SearchType type;
  final BuiltList<Search> searchList;
  final SearchDelegate<Search> searchDelegate;

  String episodesText(Search search) {
    if (type == SearchType.anime) {
      String episodes = search.episodes == 0 ? '?' : search.episodes.toString();
      return '($episodes eps)';
    } else if (type == SearchType.manga) {
      String volumes = search.volumes == 0 ? '?' : search.volumes.toString();
      return '($volumes vols)';
    } else {
      throw 'TopType Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        final Search search = searchList.elementAt(index);
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
                      Image.network(search.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(search.title, style: Theme.of(context).textTheme.subtitle),
                            Text(search.synopsis.split('.').first + '.',
                                maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption),
                            Text(search.type + ' ' + episodesText(search) + ' - ' + score, style: Theme.of(context).textTheme.caption),
                            Text(f.format(search.members) + ' members', style: Theme.of(context).textTheme.caption),
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
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  _SuggestionList({this.query, this.suggestions, this.onSelected});

  final String query;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: min(suggestions.length, 10),
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.length < 3 ? Icon(Icons.history) : Icon(Icons.search),
          title: Text(suggestion, style: Theme.of(context).textTheme.subhead),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

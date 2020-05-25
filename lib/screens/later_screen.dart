import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class LaterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Later'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
              Tab(text: 'Unknown'),
            ],
          ),
          actions: <Widget>[CustomMenu()],
        ),
        body: FutureBuilder(
          future: Jikan().getSeasonLater(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            BuiltList<AnimeItem> animeList = snapshot.data.anime;
            BuiltList<AnimeItem> tv = BuiltList.from(animeList.where((anime) => anime.type == 'TV'));
            BuiltList<AnimeItem> ona = BuiltList.from(animeList.where((anime) => anime.type == 'ONA'));
            BuiltList<AnimeItem> ova = BuiltList.from(animeList.where((anime) => anime.type == 'OVA'));
            BuiltList<AnimeItem> movie = BuiltList.from(animeList.where((anime) => anime.type == 'Movie'));
            BuiltList<AnimeItem> special = BuiltList.from(animeList.where((anime) => anime.type == 'Special'));
            BuiltList<AnimeItem> unknown = BuiltList.from(animeList.where((anime) => anime.type == '-'));
            return TabBarView(
              children: [
                SeasonList(tv),
                SeasonList(ona),
                SeasonList(ova),
                SeasonList(movie),
                SeasonList(special),
                SeasonList(unknown),
              ],
            );
          },
        ),
      ),
    );
  }
}

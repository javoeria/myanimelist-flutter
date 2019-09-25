import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/custom_menu.dart';
import 'package:myanimelist/widgets/season_list.dart';

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
          actions: <Widget>[
            CustomMenu(),
          ],
        ),
        body: FutureBuilder(
          future: JikanApi().getSeasonLater(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            BuiltList<Anime> animeList = snapshot.data.anime;
            animeList = BuiltList.from(animeList.where((anime) => anime.kids == false && anime.r18 == false));
            BuiltList<Anime> tv = BuiltList.from(animeList.where((anime) => anime.type == 'TV'));
            BuiltList<Anime> ona = BuiltList.from(animeList.where((anime) => anime.type == 'ONA'));
            BuiltList<Anime> ova = BuiltList.from(animeList.where((anime) => anime.type == 'OVA'));
            BuiltList<Anime> movie = BuiltList.from(animeList.where((anime) => anime.type == 'Movie'));
            BuiltList<Anime> special = BuiltList.from(animeList.where((anime) => anime.type == 'Special'));
            BuiltList<Anime> unknown = BuiltList.from(animeList.where((anime) => anime.type == '-'));
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

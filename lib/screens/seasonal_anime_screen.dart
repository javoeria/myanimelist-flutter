import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class SeasonalAnimeScreen extends StatelessWidget {
  SeasonalAnimeScreen({this.year, this.type});

  final int year;
  final SeasonType type;

  @override
  Widget build(BuildContext context) {
    String typeString = type.toString();
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(typeString[0].toUpperCase() + typeString.substring(1) + ' ' + year.toString()),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
            ],
          ),
          actions: <Widget>[CustomMenu()],
        ),
        body: FutureBuilder(
          future: JikanApi().getSeason(year, type),
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
            return TabBarView(
              children: [
                SeasonList(tv),
                SeasonList(ona),
                SeasonList(ova),
                SeasonList(movie),
                SeasonList(special),
              ],
            );
          },
        ),
      ),
    );
  }
}

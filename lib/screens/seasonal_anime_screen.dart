import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';
import 'package:provider/provider.dart';

class SeasonalAnimeScreen extends StatelessWidget {
  SeasonalAnimeScreen({this.year, this.type});

  final int year;
  final String type;

  SeasonType seasonClass(String season) {
    switch (season.toLowerCase()) {
      case 'spring':
        return SeasonType.spring;
        break;
      case 'summer':
        return SeasonType.summer;
        break;
      case 'fall':
        return SeasonType.fall;
        break;
      case 'winter':
        return SeasonType.winter;
        break;
      default:
        throw 'SeasonType Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$type $year'),
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
          future: Jikan().getSeason(year: year, season: seasonClass(type)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            BuiltList<AnimeItem> animeList = snapshot.data.anime;
            bool kids = Provider.of<UserData>(context).kidsGenre;
            bool r18 = Provider.of<UserData>(context).r18Genre;
            if (!kids) animeList = BuiltList.from(animeList.where((anime) => anime.kids == false));
            if (!r18) animeList = BuiltList.from(animeList.where((anime) => anime.r18 == false));
            BuiltList<AnimeItem> tv = BuiltList.from(animeList.where((anime) => anime.type == 'TV'));
            BuiltList<AnimeItem> ona = BuiltList.from(animeList.where((anime) => anime.type == 'ONA'));
            BuiltList<AnimeItem> ova = BuiltList.from(animeList.where((anime) => anime.type == 'OVA'));
            BuiltList<AnimeItem> movie = BuiltList.from(animeList.where((anime) => anime.type == 'Movie'));
            BuiltList<AnimeItem> special = BuiltList.from(animeList.where((anime) => anime.type == 'Special'));
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

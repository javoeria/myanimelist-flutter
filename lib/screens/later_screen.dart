import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
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
            tabs: const <Tab>[
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
          future: getSeasonComplete(),
          builder: (context, AsyncSnapshot<BuiltList<Anime>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            BuiltList<Anime> animeList = snapshot.data!;
            BuiltList<Anime> tv = BuiltList(animeList.where((anime) => anime.type == 'TV'));
            BuiltList<Anime> ona = BuiltList(animeList.where((anime) => anime.type == 'ONA'));
            BuiltList<Anime> ova = BuiltList(animeList.where((anime) => anime.type == 'OVA'));
            BuiltList<Anime> movie = BuiltList(animeList.where((anime) => anime.type == 'Movie'));
            BuiltList<Anime> special = BuiltList(animeList.where((anime) => anime.type == 'Special'));
            BuiltList<Anime> unknown = BuiltList(animeList.where((anime) => anime.type == null));
            return TabBarView(
              children: <Widget>[
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

  Future<BuiltList<Anime>> getSeasonComplete() async {
    BuiltList<Anime> response = BuiltList();
    int page = 0;
    while (page < 4 && response.length == page * 25) {
      response += await Jikan().getSeasonUpcoming(page: page + 1);
      page += 1;
    }
    return response;
  }
}

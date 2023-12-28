import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
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
          title: const Text('Later'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
              Tab(text: 'Unknown'),
            ],
          ),
          actions: [CustomMenu()],
        ),
        body: FutureBuilder(
          future: getSeasonComplete(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final BuiltList<Anime> animeList = snapshot.data!;
            return TabBarView(
              children: <SeasonList>[
                SeasonList(animeList.where((anime) => anime.type == 'TV').toBuiltList()),
                SeasonList(animeList.where((anime) => anime.type == 'ONA').toBuiltList()),
                SeasonList(animeList.where((anime) => anime.type == 'OVA').toBuiltList()),
                SeasonList(animeList.where((anime) => anime.type == 'Movie').toBuiltList()),
                SeasonList(animeList.where((anime) => anime.type == 'Special').toBuiltList()),
                SeasonList(animeList.where((anime) => anime.type == null).toBuiltList()),
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
      response += await jikan.getSeasonUpcoming(page: page + 1);
      page += 1;
    }
    return response;
  }
}

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class SeasonalAnimeScreen extends StatelessWidget {
  const SeasonalAnimeScreen({required this.year, required this.season});

  final int year;
  final String season;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$season $year'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
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
              ],
            );
          },
        ),
      ),
    );
  }

  Future<BuiltList<Anime>> getSeasonComplete() async {
    List<dynamic> response = await MalClient().getSeason(year, season.toLowerCase());
    List<Anime> items = response.map((item) {
      String type = ['tv', 'ova', 'ona'].contains(item['node']['media_type'])
          ? item['node']['media_type'].toString().toUpperCase()
          : item['node']['media_type'].toString().toTitleCase();
      if (item['node']['main_picture'] == null) item['node']['main_picture'] = {'medium': kDefaultPicture};
      if (item['node']['start_date'].toString().split('-').length == 2) item['node']['start_date'] += '-01';
      Map<String, dynamic> jsonMap = {
        'mal_id': item['node']['id'],
        'url': 'https://myanimelist.net/anime/${item['node']['id']}',
        'images': {
          'jpg': {'large_image_url': item['node']['main_picture']['large'] ?? item['node']['main_picture']['medium']}
        },
        'trailer': {},
        'title': item['node']['title'],
        'type': type,
        'episodes': item['node']['num_episodes'] == 0 ? null : item['node']['num_episodes'],
        'airing': item['node']['status'] == 'currently_airing',
        'aired': {'string': item['node']['start_date'].toString().formatDate()},
        'score': item['node']['mean'],
        'members': item['node']['num_list_users'],
        'synopsis': item['node']['synopsis'] == '' ? null : item['node']['synopsis'],
        'season': item['node']['start_season']['season'],
        'year': item['node']['start_season']['year'],
        'broadcast': {},
        'studios': (item['node']['studios'] ?? []).map((i) => {
              'mal_id': i['id'],
              'type': 'anime',
              'name': i['name'],
              'url': 'https://myanimelist.net/anime/producer/${i['id']}'
            }),
        'genres': (item['node']['genres'] ?? []).map((i) => {
              'mal_id': i['id'],
              'type': 'anime',
              'name': i['name'],
              'url': 'https://myanimelist.net/anime/genre/${i['id']}'
            }),
      };
      jsonMap['demographics'] = jsonMap['genres'];
      return Anime.fromJson(jsonMap);
    }).toList();

    return BuiltList(items.where((anime) => anime.year == year && anime.season == season.toLowerCase()));
  }
}

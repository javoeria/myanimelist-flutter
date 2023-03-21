import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class SeasonalAnimeScreen extends StatelessWidget {
  const SeasonalAnimeScreen({required this.year, required this.type});

  final int year;
  final String type;

  SeasonType seasonClass(String season) {
    switch (season.toLowerCase()) {
      case 'spring':
        return SeasonType.spring;
      case 'summer':
        return SeasonType.summer;
      case 'fall':
        return SeasonType.fall;
      case 'winter':
        return SeasonType.winter;
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
            tabs: const <Tab>[
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
            return TabBarView(
              children: <Widget>[
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

  Future<BuiltList<Anime>> getSeasonComplete() async {
    final DateFormat f = DateFormat('MMM d, yyyy');
    List<dynamic> response = await MalClient().getSeason(year, type.toLowerCase());
    List<Anime> season = response.map((item) {
      String type = ['tv', 'ova', 'ona'].contains(item['node']['media_type'])
          ? item['node']['media_type'].toUpperCase()
          : item['node']['media_type'][0].toUpperCase() + item['node']['media_type'].substring(1);
      if (item['node']['start_date'].toString().split('-').length == 2) item['node']['start_date'] += '-01';
      if (item['node']['main_picture'] == null) item['node']['main_picture'] = {'medium': kDefaultPicture};
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
        'aired': {'string': f.format(DateTime.parse(item['node']['start_date']))},
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

    return BuiltList(season.where((a) => a.year == year && a.season == type.toLowerCase()));
  }
}

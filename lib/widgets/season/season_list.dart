import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/season/season_info.dart';
import 'package:provider/provider.dart';

class SeasonList extends StatelessWidget {
  const SeasonList(this.items);

  final BuiltList<Anime> items;

  @override
  Widget build(BuildContext context) {
    BuiltList<Anime> animeList = BuiltList(items.where((anime) => !anime.genres.any((i) => i.name == 'Hentai')));
    if (!Provider.of<UserData>(context).kidsGenre) {
      animeList = BuiltList(animeList.where((anime) => !anime.demographics.any((i) => i.name == 'Kids')));
    }
    if (!Provider.of<UserData>(context).r18Genre) {
      animeList = BuiltList(animeList.where((anime) => !anime.genres.any((i) => i.name == 'Erotica')));
    }

    if (animeList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 0.0),
        itemCount: animeList.length,
        itemBuilder: (context, index) => SeasonInfo(animeList.elementAt(index)),
      ),
    );
  }
}

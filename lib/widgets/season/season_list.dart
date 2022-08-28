import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/season/season_info.dart';
import 'package:provider/provider.dart';

class SeasonList extends StatefulWidget {
  const SeasonList(this.animeList);

  final BuiltList<Anime> animeList;

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> with AutomaticKeepAliveClientMixin<SeasonList> {
  late BuiltList<Anime> _animeList;

  @override
  void initState() {
    super.initState();
    _animeList = widget.animeList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool kids = Provider.of<UserData>(context).kidsGenre;
    bool r18 = Provider.of<UserData>(context).r18Genre;
    _animeList = BuiltList(_animeList.where((anime) => !anime.genres.map((i) => i.name).contains('Hentai')));
    if (!kids) {
      _animeList = BuiltList(_animeList.where((anime) => !anime.demographics.map((i) => i.name).contains('Kids')));
    }
    if (!r18) {
      _animeList = BuiltList(_animeList.where((anime) => !anime.genres.map((i) => i.name).contains('Erotica')));
    }

    if (_animeList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 0.0),
        itemCount: _animeList.length,
        itemBuilder: (context, index) {
          Anime anime = _animeList.elementAt(index);
          return SeasonInfo(anime);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

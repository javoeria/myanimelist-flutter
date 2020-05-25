import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/season/season_info.dart';
import 'package:provider/provider.dart';

class SeasonList extends StatefulWidget {
  SeasonList(this.animeList);

  final BuiltList<AnimeItem> animeList;

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> with AutomaticKeepAliveClientMixin<SeasonList> {
  BuiltList<AnimeItem> _animeList;

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
    if (!kids) _animeList = BuiltList.from(_animeList.where((anime) => anime.kids == false));
    if (!r18) _animeList = BuiltList.from(_animeList.where((anime) => anime.r18 == false));

    if (_animeList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 0.0),
        itemCount: _animeList.length,
        itemBuilder: (context, index) {
          AnimeItem anime = _animeList.elementAt(index);
          return SeasonInfo(anime);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

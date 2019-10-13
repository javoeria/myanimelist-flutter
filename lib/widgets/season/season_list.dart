import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/season_info.dart';

class SeasonList extends StatefulWidget {
  SeasonList(this.animeList);

  final BuiltList<Anime> animeList;

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> with AutomaticKeepAliveClientMixin<SeasonList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 0.0),
        itemCount: widget.animeList.length,
        itemBuilder: (context, index) {
          Anime anime = widget.animeList.elementAt(index);
          return SeasonInfo(anime);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

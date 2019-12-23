import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/season/season_info.dart';

class SeasonList extends StatefulWidget {
  SeasonList(this.animeList);

  final BuiltList<AnimeItem> animeList;

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> with AutomaticKeepAliveClientMixin<SeasonList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.animeList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 0.0),
        itemCount: widget.animeList.length,
        itemBuilder: (context, index) {
          AnimeItem anime = widget.animeList.elementAt(index);
          return SeasonInfo(anime);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show DateFormat;

const int PAGE_SIZE = 100;

class AnimeEpisodeList extends StatefulWidget {
  AnimeEpisodeList(this.id);

  final int id;

  @override
  _AnimeEpisodeListState createState() => _AnimeEpisodeListState();
}

class _AnimeEpisodeListState extends State<AnimeEpisodeList> with AutomaticKeepAliveClientMixin<AnimeEpisodeList> {
  final DateFormat f = DateFormat('MMM d, yyyy');

  Widget subtitleText(String titleRomanji, String titleJapanese) {
    if (titleRomanji != null && titleJapanese != null) {
      return Text('$titleRomanji - $titleJapanese');
    } else if (titleRomanji != null) {
      return Text(titleRomanji);
    } else if (titleJapanese != null) {
      return Text(titleJapanese);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: PagewiseListView(
        pageSize: PAGE_SIZE,
        itemBuilder: this._itemBuilder,
        padding: const EdgeInsets.all(12.0),
        pageFuture: (pageIndex) => JikanApi().getAnimeEpisodes(widget.id, page: pageIndex + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, AnimeEpisode episode, int index) {
    String dateAired = episode.aired == null ? 'N/A' : f.format(DateTime.parse(episode.aired));
    return ListTile(
      title: Text(episode.title),
      subtitle: subtitleText(episode.titleRomanji, episode.titleJapanese),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(episode.episodeId.toString(), style: Theme.of(context).textTheme.title),
      ),
      trailing: Text(dateAired),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

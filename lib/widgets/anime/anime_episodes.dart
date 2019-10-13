import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show DateFormat;

class AnimeEpisodeList extends StatefulWidget {
  AnimeEpisodeList(this.id);

  final int id;

  @override
  _AnimeEpisodeListState createState() => _AnimeEpisodeListState();
}

class _AnimeEpisodeListState extends State<AnimeEpisodeList> with AutomaticKeepAliveClientMixin<AnimeEpisodeList> {
  final DateFormat f = DateFormat('MMM d, yyyy');
  Future<AnimeEpisodes> _future;

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
  void initState() {
    super.initState();
    _future = JikanApi().getAnimeEpisodes(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<AnimeEpisode> episodeList = snapshot.data.episodes;
        if (episodeList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: episodeList.length,
          itemBuilder: (context, index) {
            AnimeEpisode episode = episodeList.elementAt(index);
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
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show DateFormat;

final DateFormat f = DateFormat('MMM d, yyyy');

class AnimeEpisodeList extends StatefulWidget {
  AnimeEpisodeList(this.id);

  final int id;

  @override
  _AnimeEpisodeListState createState() => _AnimeEpisodeListState();
}

class _AnimeEpisodeListState extends State<AnimeEpisodeList> with AutomaticKeepAliveClientMixin<AnimeEpisodeList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getAnimeEpisodes(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<AnimeEpisode> episodeList = snapshot.data.episodes;
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: episodeList.length,
          itemBuilder: (context, index) {
            AnimeEpisode episode = episodeList.elementAt(index);
            return ListTile(
              title: Text(episode.title),
              subtitle: Text(episode.titleRomanji + '(${episode.titleJapanese})'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(episode.episodeId.toString(), style: Theme.of(context).textTheme.title),
              ),
              trailing: Text(f.format(DateTime.parse(episode.aired))),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeEpisodes extends StatefulWidget {
  const AnimeEpisodes(this.id);

  final int id;

  @override
  _AnimeEpisodesState createState() => _AnimeEpisodesState();
}

class _AnimeEpisodesState extends State<AnimeEpisodes> with AutomaticKeepAliveClientMixin<AnimeEpisodes> {
  final DateFormat f = DateFormat('MMM d, yyyy');

  Widget? subtitleText(String? titleRomanji, String? titleJapanese) {
    if (titleRomanji != null && titleJapanese != null) {
      return Text('$titleRomanji ($titleJapanese)');
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
        pageSize: kEpisodePageSize,
        itemBuilder: _itemBuilder,
        noItemsFoundBuilder: (context) {
          return ListTile(title: Text('No items found.'));
        },
        pageFuture: (pageIndex) => Jikan().getAnimeEpisodes(widget.id, page: pageIndex! + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Episode episode, int index) {
    String dateAired = episode.aired == null ? 'N/A' : f.format(DateTime.parse(episode.aired!));
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(episode.title),
          subtitle: subtitleText(episode.titleRomanji, episode.titleJapanese),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(episode.malId.toString(), style: Theme.of(context).textTheme.headline6),
          ),
          trailing: Text(dateAired),
          onTap: () async {
            String url = episode.url;
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        Divider(height: 0.0),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

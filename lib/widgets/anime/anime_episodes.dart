import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeEpisodes extends StatefulWidget {
  const AnimeEpisodes(this.id);

  final int id;

  @override
  State<AnimeEpisodes> createState() => _AnimeEpisodesState();
}

class _AnimeEpisodesState extends State<AnimeEpisodes> with AutomaticKeepAliveClientMixin<AnimeEpisodes> {
  Widget? subtitleText(String? titleRomanji, String? dateAired) {
    if (titleRomanji != null && dateAired != null) {
      return Text('${titleRomanji.trim()} - ${dateAired.formatDate()}');
    } else if (titleRomanji != null) {
      return Text(titleRomanji);
    } else if (dateAired != null) {
      return Text(dateAired.formatDate());
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
        noItemsFoundBuilder: (context) => ListTile(title: Text('No items found.')),
        pageFuture: (pageIndex) => jikan.getAnimeEpisodes(widget.id, page: pageIndex! + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Episode episode, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(episode.title),
          subtitle: subtitleText(episode.titleRomanji, episode.aired),
          leading: Text(episode.malId.toString(), style: Theme.of(context).textTheme.titleSmall),
          trailing: episode.score != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text((episode.score! * 2).toString(), style: Theme.of(context).textTheme.bodyLarge),
                    Icon(Icons.star, color: Colors.amber),
                  ],
                )
              : null,
          dense: true,
          onTap: () async {
            String? url = episode.url;
            if (url != null && await canLaunchUrlString(url)) {
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

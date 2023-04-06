import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';

class TopList extends StatefulWidget {
  const TopList({this.type, this.filter, this.anime = true});

  final TopType? type;
  final TopFilter? filter;
  final bool anime;

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin<TopList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kDefaultPageSize,
        itemBuilder: _itemBuilder,
        padding: const EdgeInsets.all(12.0),
        pageFuture: (pageIndex) => widget.anime
            ? jikan.getTopAnime(type: widget.type, filter: widget.filter, page: pageIndex! + 1)
            : jikan.getTopManga(type: widget.type, filter: widget.filter, page: pageIndex! + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, dynamic top, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Image.network(top.imageUrl, width: kImageWidthS, height: kImageHeightS, fit: BoxFit.cover),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Text>[
                  Text('${index + 1}. ${top.title}', style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    '${top.type ?? 'Unknown'} ${episodesText(top)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    top is Anime ? top.aired : top.published,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${(top.members as int).decimal()} members',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            widget.filter != TopFilter.upcoming
                ? Row(
                    children: <Widget>[
                      Text(top.score.toString(), style: Theme.of(context).textTheme.bodyLarge),
                      Icon(Icons.star, color: Colors.amber),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      onTap: () {
        if (widget.anime) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeScreen(top.malId, top.title, episodes: top.episodes),
              settings: const RouteSettings(name: 'AnimeScreen'),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaScreen(top.malId, top.title),
              settings: const RouteSettings(name: 'MangaScreen'),
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

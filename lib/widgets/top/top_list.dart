import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';

class TopList extends StatefulWidget {
  const TopList({this.type, this.subtype, this.anime = true});

  final TopType? type;
  final TopSubtype? subtype;
  final bool anime;

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin<TopList> {
  final NumberFormat f = NumberFormat.decimalPattern();

  String episodesText(dynamic top) {
    if (top is Anime) {
      String episodes = top.episodes == null ? '?' : top.episodes.toString();
      return '($episodes eps)';
    } else if (top is Manga) {
      String volumes = top.volumes == null ? '?' : top.volumes.toString();
      return '($volumes vols)';
    } else {
      throw 'ItemType Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kDefaultPageSize,
        itemBuilder: _itemBuilder,
        padding: const EdgeInsets.all(12.0),
        pageFuture: (pageIndex) => widget.anime
            ? Jikan().getTopAnime(type: widget.type, subtype: widget.subtype, page: pageIndex! + 1)
            : Jikan().getTopManga(type: widget.type, subtype: widget.subtype, page: pageIndex! + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, dynamic top, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.network(
                    top.imageUrl,
                    width: kImageWidthS,
                    height: kImageHeightS,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${index + 1}. ${top.title}',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          '${top.type} ${episodesText(top)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          top is Anime ? top.aired : top.published,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${f.format(top.members)} members',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.subtype != TopSubtype.upcoming
                ? Row(
                    children: <Widget>[
                      Text(top.score.toString(), style: Theme.of(context).textTheme.subtitle1),
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
              builder: (context) => AnimeScreen(top.malId, top.title),
              settings: RouteSettings(name: 'AnimeScreen'),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaScreen(top.malId, top.title),
              settings: RouteSettings(name: 'MangaScreen'),
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';

const int PAGE_SIZE = 50;

class TopList extends StatefulWidget {
  TopList({@required this.type, this.subtype});

  final TopType type;
  final TopSubtype subtype;

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin<TopList> {
  final NumberFormat f = NumberFormat.decimalPattern();

  String episodesText(Top top) {
    if (widget.type == TopType.anime) {
      String episodes = top.episodes == null ? '?' : top.episodes.toString();
      return '($episodes eps)';
    } else if (widget.type == TopType.manga) {
      String volumes = top.volumes == null ? '?' : top.volumes.toString();
      return '($volumes vols)';
    } else {
      throw 'TopType Error';
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
        pageFuture: (pageIndex) => JikanApi().getTop(widget.type, page: pageIndex + 1, subtype: widget.subtype),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Top top, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.network(top.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${top.rank}. ' + top.title, style: Theme.of(context).textTheme.subtitle),
                        Text(top.type + ' ' + episodesText(top), style: Theme.of(context).textTheme.caption),
                        Text((top.startDate ?? '') + ' - ' + (top.endDate ?? ''),
                            style: Theme.of(context).textTheme.caption),
                        Text(f.format(top.members) + ' members', style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.subtype != TopSubtype.upcoming
                ? Row(
                    children: <Widget>[
                      Text(top.score.toString(), style: Theme.of(context).textTheme.subhead),
                      Icon(Icons.star, color: Colors.amber),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      onTap: () {
        if (widget.type == TopType.anime) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnimeScreen(top.malId, top.title)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MangaScreen(top.malId, top.title)));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

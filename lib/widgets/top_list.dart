import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;

final NumberFormat f = NumberFormat.decimalPattern();

class TopList extends StatefulWidget {
  TopList({@required this.type, this.subtype});

  final TopType type;
  final TopSubtype subtype;

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin<TopList> {
  String episodesText(Top top) {
    if (widget.type == TopType.anime) {
      String episodes = top.episodes == null ? '?' : top.episodes.toString();
      return '($episodes eps)';
    } else if (widget.type == TopType.manga) {
      String volumes = top.volumes == null ? '?' : top.volumes.toString();
      return '($volumes vols)';
    } else {
      // TODO
      return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getTop(widget.type, page: 1, subtype: widget.subtype),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Top> topList = snapshot.data;
        double width = MediaQuery.of(context).size.width * 0.68;
        return ListView.builder(
          itemCount: topList.length,
          itemBuilder: (context, index) {
            Top top = topList.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.network(top.imageUrl, height: 70.0, width: 50.0, fit: BoxFit.cover),
                      Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(top.title, style: Theme.of(context).textTheme.subtitle),
                            Text(top.type + ' ' + episodesText(top), style: Theme.of(context).textTheme.caption),
                            Text((top.startDate ?? '') + ' - ' + (top.endDate ?? ''), style: Theme.of(context).textTheme.caption),
                            Text(f.format(top.members) + ' members', style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                    ],
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
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

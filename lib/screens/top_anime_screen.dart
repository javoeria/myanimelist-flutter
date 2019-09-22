import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;

final NumberFormat f = NumberFormat.decimalPattern();

class TopAnimeScreen extends StatelessWidget {
  TopAnimeScreen({this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      initialIndex: index ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Anime'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All Anime'),
              Tab(text: 'Top Airing'),
              Tab(text: 'Top Upcoming'),
              Tab(text: 'Top TV Series'),
              Tab(text: 'Top Movies'),
              Tab(text: 'Top OVAs'),
              Tab(text: 'Top Specials'),
              Tab(text: 'Most Popular'),
              Tab(text: 'Most Favorited'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TopList(),
            TopList(subtype: TopSubtype.airing),
            TopList(subtype: TopSubtype.upcoming),
            TopList(subtype: TopSubtype.tv),
            TopList(subtype: TopSubtype.movie),
            TopList(subtype: TopSubtype.ova),
            TopList(subtype: TopSubtype.special),
            TopList(subtype: TopSubtype.bypopularity),
            TopList(subtype: TopSubtype.favorite),
          ],
        ),
      ),
    );
  }
}

class TopList extends StatefulWidget {
  TopList({this.subtype});

  final TopSubtype subtype;

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin<TopList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getTop(TopType.anime, page: 1, subtype: widget.subtype),
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
            String episodes = top.episodes == null ? '?' : top.episodes.toString();
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
                            Text(top.type + ' ($episodes eps)', style: Theme.of(context).textTheme.caption),
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

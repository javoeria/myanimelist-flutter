import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;

final NumberFormat f = NumberFormat.decimalPattern();

class TopMangaScreen extends StatelessWidget {
  TopMangaScreen({this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      initialIndex: index ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Manga'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All Manga'),
              Tab(text: 'Top Manga'),
              Tab(text: 'Top Novels'),
              Tab(text: 'Top One-shots'),
              Tab(text: 'Top Doujinshi'),
              Tab(text: 'Top Manhwa'),
              Tab(text: 'Top Manhua'),
              Tab(text: 'Most Popular'),
              Tab(text: 'Most Favorited'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TopList(),
            TopList(subtype: TopSubtype.manga),
            TopList(subtype: TopSubtype.novels),
            TopList(subtype: TopSubtype.oneshots),
            TopList(subtype: TopSubtype.doujin),
            TopList(subtype: TopSubtype.manhwa),
            TopList(subtype: TopSubtype.manhua),
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
      future: JikanApi().getTop(TopType.manga, page: 1, subtype: widget.subtype),
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
            String volumes = top.volumes == null ? '?' : top.volumes.toString();
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
                            Text(top.type + ' ($volumes vols)', style: Theme.of(context).textTheme.caption),
                            Text((top.startDate ?? '') + ' - ' + (top.endDate ?? ''), style: Theme.of(context).textTheme.caption),
                            Text(f.format(top.members) + ' members', style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(top.score.toString(), style: Theme.of(context).textTheme.subhead),
                      Icon(Icons.star, color: Colors.amber),
                    ],
                  ),
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

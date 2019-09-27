import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/custom_view.dart';
import 'package:myanimelist/widgets/top_list.dart';

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
          actions: <Widget>[CustomView()],
        ),
        body: TabBarView(
          children: [
            TopList(type: TopType.manga),
            TopList(type: TopType.manga, subtype: TopSubtype.manga),
            TopList(type: TopType.manga, subtype: TopSubtype.novels),
            TopList(type: TopType.manga, subtype: TopSubtype.oneshots),
            TopList(type: TopType.manga, subtype: TopSubtype.doujin),
            TopList(type: TopType.manga, subtype: TopSubtype.manhwa),
            TopList(type: TopType.manga, subtype: TopSubtype.manhua),
            TopList(type: TopType.manga, subtype: TopSubtype.bypopularity),
            TopList(type: TopType.manga, subtype: TopSubtype.favorite),
          ],
        ),
      ),
    );
  }
}

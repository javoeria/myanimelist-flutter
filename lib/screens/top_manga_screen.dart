import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/top_grid.dart';
import 'package:myanimelist/widgets/top/top_list.dart';
import 'package:provider/provider.dart';

class TopMangaScreen extends StatelessWidget {
  TopMangaScreen({this.index});

  final int index;
  final TopType type = TopType.manga;

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
              Tab(text: 'Top One-shots'),
              Tab(text: 'Top Doujinshi'),
              Tab(text: 'Top Novels'),
              Tab(text: 'Top Manhwa'),
              Tab(text: 'Top Manhua'),
              Tab(text: 'Most Popular'),
              Tab(text: 'Most Favorited'),
            ],
          ),
          actions: <Widget>[CustomView()],
        ),
        body: Provider.of<UserData>(context).gridView
            ? TabBarView(
                children: [
                  TopGrid(type: type),
                  TopGrid(type: type, subtype: TopSubtype.manga),
                  TopGrid(type: type, subtype: TopSubtype.oneshots),
                  TopGrid(type: type, subtype: TopSubtype.doujin),
                  TopGrid(type: type, subtype: TopSubtype.novels),
                  TopGrid(type: type, subtype: TopSubtype.manhwa),
                  TopGrid(type: type, subtype: TopSubtype.manhua),
                  TopGrid(type: type, subtype: TopSubtype.bypopularity),
                  TopGrid(type: type, subtype: TopSubtype.favorite),
                ],
              )
            : TabBarView(
                children: [
                  TopList(type: type),
                  TopList(type: type, subtype: TopSubtype.manga),
                  TopList(type: type, subtype: TopSubtype.oneshots),
                  TopList(type: type, subtype: TopSubtype.doujin),
                  TopList(type: type, subtype: TopSubtype.novels),
                  TopList(type: type, subtype: TopSubtype.manhwa),
                  TopList(type: type, subtype: TopSubtype.manhua),
                  TopList(type: type, subtype: TopSubtype.bypopularity),
                  TopList(type: type, subtype: TopSubtype.favorite),
                ],
              ),
      ),
    );
  }
}

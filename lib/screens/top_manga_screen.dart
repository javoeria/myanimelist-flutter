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
        body: Provider.of<UserData>(context).gridView
            ? TabBarView(
                children: [
                  TopGrid(type: TopType.manga),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.manga),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.novels),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.oneshots),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.doujin),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.manhwa),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.manhua),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.bypopularity),
                  TopGrid(type: TopType.manga, subtype: TopSubtype.favorite),
                ],
              )
            : TabBarView(
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

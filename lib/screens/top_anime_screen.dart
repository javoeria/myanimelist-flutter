import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/top_grid.dart';
import 'package:myanimelist/widgets/top/top_list.dart';
import 'package:provider/provider.dart';

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
          actions: <Widget>[CustomView()],
        ),
        body: Provider.of<UserData>(context).gridView
            ? TabBarView(
                children: <Widget>[
                  TopGrid(type: TopType.anime),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.airing),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.upcoming),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.tv),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.movie),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.ova),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.special),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.bypopularity),
                  TopGrid(type: TopType.anime, subtype: TopSubtype.favorite),
                ],
              )
            : TabBarView(
                children: <Widget>[
                  TopList(type: TopType.anime),
                  TopList(type: TopType.anime, subtype: TopSubtype.airing),
                  TopList(type: TopType.anime, subtype: TopSubtype.upcoming),
                  TopList(type: TopType.anime, subtype: TopSubtype.tv),
                  TopList(type: TopType.anime, subtype: TopSubtype.movie),
                  TopList(type: TopType.anime, subtype: TopSubtype.ova),
                  TopList(type: TopType.anime, subtype: TopSubtype.special),
                  TopList(type: TopType.anime, subtype: TopSubtype.bypopularity),
                  TopList(type: TopType.anime, subtype: TopSubtype.favorite),
                ],
              ),
      ),
    );
  }
}

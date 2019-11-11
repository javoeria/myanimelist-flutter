import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/top_grid.dart';
import 'package:myanimelist/widgets/top/top_list.dart';
import 'package:provider/provider.dart';

class TopAnimeScreen extends StatelessWidget {
  TopAnimeScreen({this.index});

  final int index;
  final TopType type = TopType.anime;

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
                  TopGrid(type: type),
                  TopGrid(type: type, subtype: TopSubtype.airing),
                  TopGrid(type: type, subtype: TopSubtype.upcoming),
                  TopGrid(type: type, subtype: TopSubtype.tv),
                  TopGrid(type: type, subtype: TopSubtype.movie),
                  TopGrid(type: type, subtype: TopSubtype.ova),
                  TopGrid(type: type, subtype: TopSubtype.special),
                  TopGrid(type: type, subtype: TopSubtype.bypopularity),
                  TopGrid(type: type, subtype: TopSubtype.favorite),
                ],
              )
            : TabBarView(
                children: <Widget>[
                  TopList(type: type),
                  TopList(type: type, subtype: TopSubtype.airing),
                  TopList(type: type, subtype: TopSubtype.upcoming),
                  TopList(type: type, subtype: TopSubtype.tv),
                  TopList(type: type, subtype: TopSubtype.movie),
                  TopList(type: type, subtype: TopSubtype.ova),
                  TopList(type: type, subtype: TopSubtype.special),
                  TopList(type: type, subtype: TopSubtype.bypopularity),
                  TopList(type: type, subtype: TopSubtype.favorite),
                ],
              ),
      ),
    );
  }
}

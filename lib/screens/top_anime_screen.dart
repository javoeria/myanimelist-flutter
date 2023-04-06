import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/top_grid.dart';
import 'package:myanimelist/widgets/top/top_list.dart';
import 'package:provider/provider.dart';

class TopAnimeScreen extends StatelessWidget {
  const TopAnimeScreen({this.index = 0});

  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      initialIndex: index,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Anime'),
          bottom: TabBar(
            isScrollable: true,
            tabs: const <Tab>[
              Tab(text: 'All Anime'),
              Tab(text: 'Top Airing'),
              Tab(text: 'Top Upcoming'),
              Tab(text: 'Top TV Series'),
              Tab(text: 'Top Movies'),
              Tab(text: 'Top OVAs'),
              Tab(text: 'Top ONAs'),
              Tab(text: 'Top Specials'),
              Tab(text: 'Most Popular'),
              Tab(text: 'Most Favorited'),
            ],
          ),
          actions: [CustomView()],
        ),
        body: Provider.of<UserData>(context).gridView
            ? TabBarView(
                children: const <TopGrid>[
                  TopGrid(),
                  TopGrid(filter: TopFilter.airing),
                  TopGrid(filter: TopFilter.upcoming),
                  TopGrid(type: TopType.tv),
                  TopGrid(type: TopType.movie),
                  TopGrid(type: TopType.ova),
                  TopGrid(type: TopType.ona),
                  TopGrid(type: TopType.special),
                  TopGrid(filter: TopFilter.bypopularity),
                  TopGrid(filter: TopFilter.favorite),
                ],
              )
            : TabBarView(
                children: const <TopList>[
                  TopList(),
                  TopList(filter: TopFilter.airing),
                  TopList(filter: TopFilter.upcoming),
                  TopList(type: TopType.tv),
                  TopList(type: TopType.movie),
                  TopList(type: TopType.ova),
                  TopList(type: TopType.ona),
                  TopList(type: TopType.special),
                  TopList(filter: TopFilter.bypopularity),
                  TopList(filter: TopFilter.favorite),
                ],
              ),
      ),
    );
  }
}

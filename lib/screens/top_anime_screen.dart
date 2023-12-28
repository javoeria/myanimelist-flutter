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
          title: const Text('Top Anime'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
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
            ? const TabBarView(
                children: <TopGrid>[
                  TopGrid(),
                  TopGrid(filter: TopFilter.airing),
                  TopGrid(filter: TopFilter.upcoming),
                  TopGrid(type: AnimeType.tv),
                  TopGrid(type: AnimeType.movie),
                  TopGrid(type: AnimeType.ova),
                  TopGrid(type: AnimeType.ona),
                  TopGrid(type: AnimeType.special),
                  TopGrid(filter: TopFilter.bypopularity),
                  TopGrid(filter: TopFilter.favorite),
                ],
              )
            : const TabBarView(
                children: <TopList>[
                  TopList(),
                  TopList(filter: TopFilter.airing),
                  TopList(filter: TopFilter.upcoming),
                  TopList(type: AnimeType.tv),
                  TopList(type: AnimeType.movie),
                  TopList(type: AnimeType.ova),
                  TopList(type: AnimeType.ona),
                  TopList(type: AnimeType.special),
                  TopList(filter: TopFilter.bypopularity),
                  TopList(filter: TopFilter.favorite),
                ],
              ),
      ),
    );
  }
}

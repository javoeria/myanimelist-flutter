import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/top_grid.dart';
import 'package:myanimelist/widgets/top/top_list.dart';
import 'package:provider/provider.dart';

class TopMangaScreen extends StatelessWidget {
  const TopMangaScreen({this.index = 0});

  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      initialIndex: index,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Manga'),
          bottom: TabBar(
            isScrollable: true,
            tabs: const <Tab>[
              Tab(text: 'All Manga'),
              Tab(text: 'Top Manga'),
              Tab(text: 'Top One-shots'),
              Tab(text: 'Top Doujinshi'),
              Tab(text: 'Top Light Novels'),
              Tab(text: 'Top Novels'),
              Tab(text: 'Top Manhwa'),
              Tab(text: 'Top Manhua'),
              Tab(text: 'Most Popular'),
              Tab(text: 'Most Favorited'),
            ],
          ),
          actions: [CustomView()],
        ),
        body: Provider.of<UserData>(context).gridView
            ? TabBarView(
                children: const <TopGrid>[
                  TopGrid(anime: false),
                  TopGrid(type: TopType.manga, anime: false),
                  TopGrid(type: TopType.oneshots, anime: false),
                  TopGrid(type: TopType.doujin, anime: false),
                  TopGrid(type: TopType.lightnovels, anime: false),
                  TopGrid(type: TopType.novels, anime: false),
                  TopGrid(type: TopType.manhwa, anime: false),
                  TopGrid(type: TopType.manhua, anime: false),
                  TopGrid(filter: TopFilter.bypopularity, anime: false),
                  TopGrid(filter: TopFilter.favorite, anime: false),
                ],
              )
            : TabBarView(
                children: const <TopList>[
                  TopList(anime: false),
                  TopList(type: TopType.manga, anime: false),
                  TopList(type: TopType.oneshots, anime: false),
                  TopList(type: TopType.doujin, anime: false),
                  TopList(type: TopType.lightnovels, anime: false),
                  TopList(type: TopType.novels, anime: false),
                  TopList(type: TopType.manhwa, anime: false),
                  TopList(type: TopType.manhua, anime: false),
                  TopList(filter: TopFilter.bypopularity, anime: false),
                  TopList(filter: TopFilter.favorite, anime: false),
                ],
              ),
      ),
    );
  }
}

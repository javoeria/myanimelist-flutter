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
          title: const Text('Top Manga'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
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
            ? const TabBarView(
                children: <TopGrid>[
                  TopGrid(anime: false),
                  TopGrid(type: MangaType.manga, anime: false),
                  TopGrid(type: MangaType.oneshot, anime: false),
                  TopGrid(type: MangaType.doujin, anime: false),
                  TopGrid(type: MangaType.lightnovel, anime: false),
                  TopGrid(type: MangaType.novel, anime: false),
                  TopGrid(type: MangaType.manhwa, anime: false),
                  TopGrid(type: MangaType.manhua, anime: false),
                  TopGrid(filter: TopFilter.bypopularity, anime: false),
                  TopGrid(filter: TopFilter.favorite, anime: false),
                ],
              )
            : const TabBarView(
                children: <TopList>[
                  TopList(anime: false),
                  TopList(type: MangaType.manga, anime: false),
                  TopList(type: MangaType.oneshot, anime: false),
                  TopList(type: MangaType.doujin, anime: false),
                  TopList(type: MangaType.lightnovel, anime: false),
                  TopList(type: MangaType.novel, anime: false),
                  TopList(type: MangaType.manhwa, anime: false),
                  TopList(type: MangaType.manhua, anime: false),
                  TopList(filter: TopFilter.bypopularity, anime: false),
                  TopList(filter: TopFilter.favorite, anime: false),
                ],
              ),
      ),
    );
  }
}

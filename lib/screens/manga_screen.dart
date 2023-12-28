import 'package:flutter/material.dart';
import 'package:myanimelist/widgets/anime/anime_forum.dart';
import 'package:myanimelist/widgets/anime/anime_news.dart';
import 'package:myanimelist/widgets/anime/anime_recommendations.dart';
import 'package:myanimelist/widgets/anime/anime_reviews.dart';
import 'package:myanimelist/widgets/anime/anime_stats.dart';
import 'package:myanimelist/widgets/manga/manga_characters.dart';
import 'package:myanimelist/widgets/manga/manga_details.dart';

class MangaScreen extends StatelessWidget {
  const MangaScreen(this.id, this.title);

  final int id;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? 'Manga'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              Tab(text: 'Details'),
              Tab(text: 'Characters'),
              Tab(text: 'Stats'),
              Tab(text: 'Reviews'),
              Tab(text: 'Recommendations'),
              Tab(text: 'News'),
              Tab(text: 'Forum'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MangaDetails(id),
            MangaCharacters(id),
            AnimeStats(id, anime: false),
            AnimeReviews(id, anime: false),
            AnimeRecommendations(id, anime: false),
            AnimeNews(id, anime: false),
            AnimeForum(id, anime: false),
          ],
        ),
      ),
    );
  }
}

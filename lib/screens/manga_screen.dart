import 'package:flutter/material.dart';
import 'package:myanimelist/widgets/anime/anime_forum.dart';
import 'package:myanimelist/widgets/anime/anime_news.dart';
import 'package:myanimelist/widgets/anime/anime_recommendations.dart';
import 'package:myanimelist/widgets/anime/anime_reviews.dart';
import 'package:myanimelist/widgets/anime/anime_stats.dart';
import 'package:myanimelist/widgets/manga/manga_characters.dart';
import 'package:myanimelist/widgets/manga/manga_details.dart';

class MangaScreen extends StatelessWidget {
  MangaScreen(this.id, this.title);

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
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Reviews'),
              Tab(text: 'Recommendations'),
              Tab(text: 'Stats'),
              Tab(text: 'Characters'),
              Tab(text: 'News'),
              Tab(text: 'Forum'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MangaDetails(id),
            AnimeReviews(id, anime: false),
            AnimeRecommendations(id, anime: false),
            AnimeStats(id, anime: false),
            MangaCharacters(id),
            AnimeNews(id, anime: false),
            AnimeForum(id, anime: false),
          ],
        ),
      ),
    );
  }
}

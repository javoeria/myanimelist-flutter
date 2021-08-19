import 'package:flutter/material.dart';
import 'package:myanimelist/widgets/anime/anime_characters_staff.dart';
import 'package:myanimelist/widgets/anime/anime_details.dart';
import 'package:myanimelist/widgets/anime/anime_episodes.dart';
import 'package:myanimelist/widgets/anime/anime_forum.dart';
import 'package:myanimelist/widgets/anime/anime_news.dart';
import 'package:myanimelist/widgets/anime/anime_recommendations.dart';
import 'package:myanimelist/widgets/anime/anime_reviews.dart';
import 'package:myanimelist/widgets/anime/anime_stats.dart';
import 'package:myanimelist/widgets/anime/anime_videos.dart';

class AnimeScreen extends StatelessWidget {
  AnimeScreen(this.id, this.title);

  final int id;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? 'Anime'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Videos'),
              Tab(text: 'Episodes'),
              Tab(text: 'Reviews'),
              Tab(text: 'Recommendations'),
              Tab(text: 'Stats'),
              Tab(text: 'Characters & Staff'),
              Tab(text: 'News'),
              Tab(text: 'Forum'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AnimeDetails(id),
            AnimeVideos(id),
            AnimeEpisodes(id),
            AnimeReviews(id),
            AnimeRecommendations(id),
            AnimeStats(id),
            AnimeCharactersStaff(id),
            AnimeNews(id),
            AnimeForum(id),
          ],
        ),
      ),
    );
  }
}

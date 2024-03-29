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
  const AnimeScreen(this.id, this.title, {this.episodes});

  final int id;
  final String? title;
  final int? episodes;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: episodes != 1 ? 9 : 8,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? 'Anime'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              const Tab(text: 'Details'),
              const Tab(text: 'Characters & Staff'),
              if (episodes != 1) const Tab(text: 'Episodes'),
              const Tab(text: 'Videos'),
              const Tab(text: 'Stats'),
              const Tab(text: 'Reviews'),
              const Tab(text: 'Recommendations'),
              const Tab(text: 'News'),
              const Tab(text: 'Forum'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AnimeDetails(id),
            AnimeCharactersStaff(id),
            if (episodes != 1) AnimeEpisodes(id),
            AnimeVideos(id),
            AnimeStats(id),
            AnimeReviews(id),
            AnimeRecommendations(id),
            AnimeNews(id),
            AnimeForum(id),
          ],
        ),
      ),
    );
  }
}

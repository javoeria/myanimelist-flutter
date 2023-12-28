import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({this.anime = true});

  final bool anime;

  @override
  Widget build(BuildContext context) {
    final ItemType type = anime ? ItemType.anime : ItemType.manga;
    return Scaffold(
      appBar: AppBar(title: Text(anime ? 'Anime Recommendations' : 'Manga Recommendations')),
      body: FutureBuilder(
        future: anime ? jikan.getRecentAnimeRecommendations() : jikan.getRecentMangaRecommendations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final BuiltList<UserRecommendation> recommendationList = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemCount: recommendationList.length,
              itemBuilder: (context, index) {
                UserRecommendation rec = recommendationList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('If you liked'),
                              const SizedBox(height: 8.0),
                              TitleAnime(
                                rec.entry[0].malId,
                                rec.entry[0].title,
                                rec.entry[0].imageUrl,
                                type: type,
                              ),
                            ],
                          ),
                          const Icon(Icons.swap_horiz),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text('...then you might like'),
                              const SizedBox(height: 8.0),
                              TitleAnime(
                                rec.entry[1].malId,
                                rec.entry[1].title,
                                rec.entry[1].imageUrl,
                                type: type,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(rec.content),
                      const SizedBox(height: 4.0),
                      Text(
                        '${anime ? 'Anime' : 'Manga'} rec by ${rec.user.username} - ${rec.date.formatDate()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

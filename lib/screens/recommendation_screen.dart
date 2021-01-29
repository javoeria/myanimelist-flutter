import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/jikan_v4.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RecommendationScreen extends StatelessWidget {
  RecommendationScreen({this.anime = true});

  final bool anime;

  @override
  Widget build(BuildContext context) {
    TopType type = anime ? TopType.anime : TopType.manga;
    return Scaffold(
      appBar: AppBar(
        title: Text(anime ? 'Anime Recommendations' : 'Manga Recommendations'),
      ),
      body: FutureBuilder(
        future: JikanV4().getRecommendations(anime: anime),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> items = snapshot.data;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = items.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleAnime(
                            item['entry'][0]['mal_id'],
                            item['entry'][0]['title'],
                            item['entry'][0]['images']['jpg']['large_image_url'],
                            type: type,
                          ),
                          Icon(Icons.swap_horiz),
                          TitleAnime(
                            item['entry'][1]['mal_id'],
                            item['entry'][1]['title'],
                            item['entry'][1]['images']['jpg']['large_image_url'],
                            type: type,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(item['content']),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RecommendationScreen extends StatelessWidget {
  RecommendationScreen({this.anime = true});

  final bool anime;
  final DateFormat f = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    ItemType type = anime ? ItemType.anime : ItemType.manga;
    return Scaffold(
      appBar: AppBar(
        title: Text(anime ? 'Anime Recommendations' : 'Manga Recommendations'),
      ),
      body: FutureBuilder(
        future: anime ? Jikan().getRecentAnimeRecommendations() : Jikan().getRecentMangaRecommendations(),
        builder: (context, AsyncSnapshot<BuiltList<UserRecommendation>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          BuiltList<UserRecommendation> items = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                UserRecommendation item = items.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TitleAnime(
                            item.entry[0].malId,
                            item.entry[0].title,
                            item.entry[0].imageUrl,
                            type: type,
                          ),
                          Icon(Icons.swap_horiz),
                          TitleAnime(
                            item.entry[1].malId,
                            item.entry[1].title,
                            item.entry[1].imageUrl,
                            type: type,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(item.content),
                      SizedBox(height: 8.0),
                      Text((anime ? 'Anime' : 'Manga') +
                          ' rec by ${item.user.username} - ${f.format(DateTime.parse(item.date))}'),
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

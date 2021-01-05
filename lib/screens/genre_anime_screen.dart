import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class GenreAnimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, int> items = {
      'Action': 1,
      'Adventure': 2,
      'Cars': 3,
      'Comedy': 4,
      'Dementia': 5,
      'Demons': 6,
      'Drama': 8,
      'Ecchi': 9,
      'Fantasy': 10,
      'Game': 11,
      'Harem': 35,
//    'Hentai': 12,
      'Historical': 13,
      'Horror': 14,
      'Josei': 43,
      'Kids': 15,
      'Magic': 16,
      'Martial Arts': 17,
      'Mecha': 18,
      'Military': 38,
      'Music': 19,
      'Mystery': 7,
      'Parody': 20,
      'Police': 39,
      'Psychological': 40,
      'Romance': 22,
      'Samurai': 21,
      'School': 23,
      'Sci-Fi': 24,
      'Seinen': 42,
      'Shoujo': 25,
      'Shoujo Ai': 26,
      'Shounen': 27,
      'Shounen Ai': 28,
      'Slice of Life': 36,
      'Space': 29,
      'Sports': 30,
      'Super Power': 31,
      'Supernatural': 37,
      'Thriller': 41,
      'Vampire': 32,
      'Yaoi': 33,
      'Yuri': 34,
    };

    List<String> keys = items.keys.toList();
    List<int> values = items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Genres Anime'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(keys.elementAt(index)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreAnimeList(values[index], keys[index]),
                    settings: RouteSettings(name: "GenreAnime${keys[index]}"),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GenreAnimeList extends StatelessWidget {
  GenreAnimeList(this.id, this.genre);

  final int id;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Anime'),
      ),
      body: FutureBuilder(
        future: Jikan().getGenre(GenreType.anime, Genre.values[id - 1]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          GenreList genre = snapshot.data;
          return SeasonList(genre.anime);
        },
      ),
    );
  }
}

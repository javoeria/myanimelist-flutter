import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/genre_anime_screen.dart';
import 'package:myanimelist/screens/genre_manga_screen.dart';

class GenreHorizontal extends StatelessWidget {
  const GenreHorizontal(this.genreList, {this.anime = true});

  final BuiltList<GenericInfo> genreList;
  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: genreList.length,
        itemBuilder: (context, index) {
          GenericInfo genre = genreList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ActionChip(
              label: Text(genre.name),
              onPressed: () {
                if (anime) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenreAnimeList(genre.malId, genre.name),
                      settings: RouteSettings(name: '${genre.name}AnimeScreen'),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenreMangaList(genre.malId, genre.name),
                      settings: RouteSettings(name: '${genre.name}MangaScreen'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class SeasonInfo extends StatelessWidget {
  SeasonInfo(this.anime);

  final Anime anime;
  final NumberFormat f = NumberFormat.compact();

  String get _studiosText {
    return anime.studios.isEmpty ? '-' : anime.studios.first.name;
  }

  String get _airingText {
    return anime.aired == null ? '??' : anime.aired!.split(' to ').first;
  }

  @override
  Widget build(BuildContext context) {
    String episodes = anime.episodes == null ? '?' : anime.episodes.toString();
    String score = anime.score == null ? 'N/A' : anime.score.toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeScreen(anime.malId, anime.title),
            settings: RouteSettings(name: 'AnimeScreen'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Text(anime.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 4.0),
            Text('${anime.type} | $_studiosText | $episodes eps'),
            SizedBox(height: 4.0),
            GenreHorizontal(anime.genres),
            SizedBox(height: 4.0),
            SizedBox(
              height: kImageHeightXL,
              child: Row(
                children: <Widget>[
                  Image.network(anime.imageUrl, width: kImageWidthXL, height: kImageHeightXL, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Text(
                          anime.synopsis ?? '(No synopsis yet.)',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_airingText),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, color: Colors.grey, size: 20.0),
                    Text(score),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, color: Colors.grey, size: 20.0),
                    Text(f.format(anime.members)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

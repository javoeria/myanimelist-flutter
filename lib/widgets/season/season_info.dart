import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class SeasonInfo extends StatelessWidget {
  const SeasonInfo(this.anime);

  final Anime anime;

  String get _studiosText => anime.studios.isEmpty ? '-' : anime.studios.first.name;
  String get _episodesText => anime.episodes == null ? '?' : anime.episodes.toString();
  String get _airedText => anime.aired == null ? '??' : anime.aired!.split(' to ').first;
  String get _scoreText => anime.score == null ? 'N/A' : anime.score.toString();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: <Widget>[
            Text(anime.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            Text('${anime.type ?? 'Unknown'} | $_studiosText | $_episodesText eps'),
            anime.genres.isNotEmpty ? GenreHorizontal(anime.genres) : Container(),
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
                          style: Theme.of(context).textTheme.bodySmall,
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
                Text(_airedText),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, size: 20.0, color: Colors.grey),
                    Text(_scoreText),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, size: 20.0, color: Colors.grey),
                    Text(anime.members!.compact()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeScreen(anime.malId, anime.title, episodes: anime.episodes),
            settings: const RouteSettings(name: 'AnimeScreen'),
          ),
        );
      },
    );
  }
}

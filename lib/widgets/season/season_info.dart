import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class SeasonInfo extends StatelessWidget {
  SeasonInfo(this.anime);

  final AnimeItem anime;
  final NumberFormat f = NumberFormat.decimalPattern();
  final DateFormat dateFormat = DateFormat('MMM d, yyyy, HH:mm');
  final DateFormat dateFormat2 = DateFormat('MMM d, yyyy');

  String get _producersText {
    return anime.producers.isEmpty ? '-' : anime.producers.first.name;
  }

  String get _airingText {
    if (anime.airingStart == null) {
      return '??';
    } else {
      DateTime japanTime = DateTime.parse(anime.airingStart).add(Duration(hours: 9));
      return anime.type == 'TV' ? '${dateFormat.format(japanTime)} (JST)' : dateFormat2.format(japanTime);
    }
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
            Text('$_producersText | $episodes eps | ${anime.source}'),
            SizedBox(height: 4.0),
            GenreHorizontal(anime.genres),
            SizedBox(height: 4.0),
            Container(
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
                          anime.synopsis ?? 'No synopsis information has been added to this title.',
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
                Text('${anime.type} - $_airingText'),
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

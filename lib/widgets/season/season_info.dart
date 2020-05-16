import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class SeasonInfo extends StatelessWidget {
  SeasonInfo(this.anime);

  final AnimeItem anime;
  final NumberFormat f = NumberFormat.decimalPattern();
  final DateFormat dateFormat = DateFormat('MMM d, yyyy, HH:mm');

  String producersText(BuiltList<GenericInfo> producers) {
    if (producers.isEmpty) {
      return '-';
    } else {
      List<String> names = [];
      for (GenericInfo p in producers) {
        names.add(p.name);
      }
      return names.join(', ');
    }
  }

  String airingText(String date) {
    if (date == null) {
      return '??';
    } else {
      DateTime dateTime = DateTime.parse(date).add(Duration(hours: 9));
      return dateFormat.format(dateTime) + ' (JST)';
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
            Text(anime.title, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 4.0),
            Text(producersText(anime.producers) + ' | $episodes eps | ' + anime.source),
            SizedBox(height: 4.0),
            GenreHorizontal(anime.genres, padding: 0.0),
            SizedBox(height: 4.0),
            Container(
              height: 242.0,
              child: Row(
                children: <Widget>[
                  Image.network(anime.imageUrl, width: 167.0, height: 242.0, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Text(anime.synopsis, style: Theme.of(context).textTheme.caption),
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
                Text(anime.type + ' - ' + airingText(anime.airingStart)),
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
